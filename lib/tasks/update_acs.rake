namespace :acs do
  desc "Update ACS tasks"
  task update: :environment do
    file_path = Rails.root.join("db/data/private_airplane_acs_6.pdf")
    acs = PdfParser.extract_ppl(file_path)

    File.write(Rails.root.join("db/data/ppl.json"), JSON.generate(acs))
  end
end
