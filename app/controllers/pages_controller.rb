class PagesController < ApplicationController
  allow_unauthenticated_access only: %i[index]
  before_action :resume_session, only: :index

  def index
  end
end
