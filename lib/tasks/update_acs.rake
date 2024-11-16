require_relative "../acs/pdf_parser"

namespace :acs do
  desc "Update ACS tasks"
  task update: :environment do
    file_path = Rails.root.join("private_airplane_acs_6.pdf")
    acs = PdfParser.extract_tasks(file_path)

    File.write(Rails.root.join("lib/acs/ppl.json"), JSON.generate(acs))
  end
end
