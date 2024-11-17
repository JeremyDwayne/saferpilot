require "pdf-reader"

class PdfParser
  def self.extract_ppl(file_path)
    reader = PDF::Reader.new(file_path)
    areas_of_operation = []
    current_area = nil
    current_task = nil
    last_code = nil
    last_area_name = nil
    last_field = nil

    reader.pages.each_with_index do |page, index|
      next if index < 9 || index >= 73

      lines = page.text.split("\n")

      lines.each do |line|
        line = line.strip
        next if line.empty?
        next if line.match?(/^Private Pilot for Airplane Category ACS.*\d+$/)

        # Detect Area of Operation
        if line.match?(/^Area of Operation\s+[IVXLCDM]+\.\s+.+$/)
          area_name = line.sub(/^Area of Operation\s+[IVXLCDM]+\.\s+/, "")
          if area_name != last_area_name
            current_area = {
              name: area_name,
              tasks: []
            }
            areas_of_operation << current_area
            current_task = nil
            last_field = nil
            last_area_name = area_name
            last_code = nil
          end

        # Detect Task
        elsif line.match?(/^\s*Task [A-Z]\.\s+/)
          current_task = {
            name: line.sub(/^\s*Task [A-Z]\.\s+/, ""),
            references: [],
            objective: "",
            note: [],
            knowledge: {},
            risk_management: {},
            skills: {}
          }
          current_area[:tasks] << current_task if current_area
          last_field = :task
          last_code = nil

        # Detect References
        elsif line.match?(/^\s*References:/)
          references = line.sub("References:", "").strip.split(/[,;]/).map(&:strip)
          current_task[:references] = references if current_task
          last_field = :reference

        # Detect Objective
        elsif line.match?(/^\s*Objective:/)
          objective = line.sub("Objective:", "").strip
          current_task[:objective] = objective if current_task
          last_field = :objective

        # Detect Note
        elsif line.match?(/^\s*Note:/)
          note = line.sub("Note:", "").strip
          current_task[:note] << note if current_task
          last_field = :note

        # Detect Knowledge, Risk Management, and Skills headers
        elsif line.match?(/^\s*Knowledge:/)
          last_field = :knowledge
          next
        elsif line.match?(/^\s*Management:/)
          last_field = :risk_management
          next
        elsif line.match?(/^\s*Skills:/)
          last_field = :skill
          next

        # Detect ACS Sub-elements (e.g., PA.I.A.K1, PA.I.A.R1, PA.I.A.S1)
        elsif line.match?(/\s*PA\.\w+\.\w+\.[KRS]\d+\w?/)
          match = line.match(/\s*(PA\.\w+\.\w+\.([KRS])\d+(\w?))\s+(.+)/)
          if match
            code, type, sub_type, description = match[1], match[2], match[3], match[4]
            element = {description: description}

            if !sub_type.empty?
              code = code.sub(sub_type, "")
              element[:sub_type] = sub_type
              element[:parent_code] = code
            end
            last_code = code

            if current_task[:knowledge][code].nil? && type == "K"
              current_task[:knowledge][code] = []
            end
            if current_task[:risk_management][code].nil? && type == "R"
              current_task[:risk_management][code] = []
            end
            if current_task[:skills][code].nil? && type == "S"
              current_task[:skills][code] = []
            end

            if type == "K"
              current_task[:knowledge][code] << element
              last_field = :knowledge
            elsif type == "R"
              current_task[:risk_management][code] << element
              last_field = :risk_management
            elsif type == "S"
              current_task[:skills][code] << element
              last_field = :skills
            end
          end

        # Detect Multiline Descriptions
        elsif current_task
          if last_field
            case last_field
            when :objective
              current_task[:objective] += " #{line}"
            when :reference
              references = line.strip.split(/[,;]/).map(&:strip)
              current_task[:references] += references
            when :note
              current_task[:note][-1] += " #{line}"
            when :knowledge
              current_task[:knowledge][last_code].last[:description] += " #{line}"
            when :risk_management
              current_task[:risk_management][last_code].last[:description] += " #{line}"
            when :skills
              current_task[:skills][last_code].last[:description] += " #{line}"
            end
          end
        end
      end
    end

    {areas_of_operation: areas_of_operation}
  end
end
