module NanoidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_uuid

    private

    def generate_uuid
      self.id ||= Nanoid.generate
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include(NanoidPrimaryKey)
end
