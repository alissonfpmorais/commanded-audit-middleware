defmodule Commanded.Middleware.Auditing.Repo.Migrations.CreateGinIndexOnCommandstoreCommandAuditData do
  use Ecto.Migration

  @data_column_db_type Application.compile_env(
                         :commanded_audit_middleware,
                         :data_column_db_type,
                         :bytea
                       )
  @metadata_column_db_type Application.compile_env(
                             :commanded_audit_middleware,
                             :metadata_column_db_type,
                             :bytea
                           )

  def up do
    if @data_column_db_type == :jsonb do
      execute(
        "CREATE INDEX IF NOT EXISTS command_audit_data_gin ON command_audit USING GIN (data);"
      )
    end

    if @metadata_column_db_type == :jsonb do
      execute(
        "CREATE INDEX IF NOT EXISTS command_audit_metadata_gin ON command_audit USING GIN (metadata);"
      )
    end
  end

  def down do
    execute("DROP INDEX IF EXISTS command_audit_metadata_gin;")
    execute("DROP INDEX IF EXISTS command_audit_data_gin;")
  end
end
