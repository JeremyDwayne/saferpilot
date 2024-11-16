class TasksController < ApplicationController
  def index
    file_path = Rails.root.join("private_airplane_acs_6.pdf")
    tasks = PdfParser.extract_tasks(file_path)
    render json: tasks
  end
end
