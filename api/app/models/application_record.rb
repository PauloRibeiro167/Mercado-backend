class ApplicationRecord < ActiveRecord::Base

  include Discard::Model if defined?(Discard::Model)

  after_commit :avisar_frontends, on: [:create, :update]

  private

  def avisar_frontends
    ActionCable.server.broadcast("application_records_channel", { acao: "atualizado", id: self.id })
  end

  public
  primary_abstract_class

  connects_to database: { writing: :primary, reading: :primary_replica }
end
