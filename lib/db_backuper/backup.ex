defmodule DbBackuper.Backup do
	alias ExAws.S3

  @bucket "codered-dbbackups"
  @file_name "backup.sql"

  def execute do
    apps()
    |> Enum.each(fn(app) ->
      run(app)
    end)
  end

  defp run(app) do
    app_name = String.downcase(app)
    root_path = Path.expand("")
    folder = Timex.now |> Timex.format!("%Y.%m.%d.%H.%M.%S", :strftime)

    command = "pg_dump --format=tar --no-privileges --dbname=#{db_credentials(app)} > #{root_path}/#{@file_name}"

    System.cmd "sh", ["-c", command]

    S3.Upload.stream_file("#{root_path}/#{@file_name}")
    |> S3.upload(@bucket, "#{app_name}/#{folder}/#{@file_name}")
    |> ExAws.request!

    File.rm("#{root_path}/#{@file_name}")

    delete_old_files(app_name)
    :ok
  end

  defp apps do
    (System.get_env("APPS") || "")
    |> String.split
  end

  defp db_credentials(app) do
    System.get_env("#{app}_CREDENTIALS")
  end

  defp delete_old_files(app_name) do
    stored_backups = S3.list_objects(@bucket, prefix: app_name)
                     |> ExAws.request!
                     |> Map.get(:body, %{})
                     |> Map.get(:contents, [])
                     |> Enum.reverse

    if Enum.count(stored_backups) > 10 do
      stored_backups
      |> Enum.drop(10)
      |> Enum.each(fn(object) ->
        S3.delete_object(@bucket, object.key)
         |> ExAws.request!
      end)
    end
  end
end
