defmodule LiveStudyWeb.DeskLive do
  use LiveStudyWeb, :live_view

  alias LiveStudy.Desks
  alias LiveStudy.Desks.Desk

  # @s3_bucket "liveview-uploads"
  # @s3_url "//#{s3_bucket}.s3.amazonaws.com"
  # @s3_region "us-west-2"

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Desks.subscribe()

    socket =
      socket
      |> assign_form(Desks.change_desk(%Desk{}))
      |> stream(:desks, Desks.list_desks())
      |> allow_upload(:photos,
        accept: ~w(.png .jpg .jpeg),
        max_entries: 3,
        max_file_size: 10_000_000,
        external: &presign_upload/2
      )

    {:ok, socket}
  end

  @impl true
  def handle_info({:desk_created, desk}, socket) do
    {:noreply, stream_insert(socket, :desks, desk, at: 0)}
  end

  @impl true
  def handle_event("validate", %{"desk" => params}, socket) do
    changeset =
      %Desk{}
      |> Desks.change_desk(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"desk" => params}, socket) do
    photo_locations =
      consume_uploaded_entries(socket, :photos, fn meta, entry ->
        # Local
        dest = Path.join(["priv", "static", "uploads", filename(entry)])
        File.cp!(meta.path, dest)

        url_path = static_path(socket, "/uploads/#{Path.basename(dest)}")

        # Amazon S3
        # url_path = Path.join(@s3_url, filename(entry))

        {:ok, url_path}
      end)

    params = Map.put(params, "photo_locations", photo_locations)

    case Desks.create_desk(params) do
      {:ok, _desk} ->
        changeset = Desks.change_desk(%Desk{})
        {:noreply, assign_form(socket, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photos, ref)}
  end

  defp assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp presign_upload(entry, socket) do
    config = %{
      region: @s3_region,
      access_key_id: System.fetch_env!("AWS_ACCESS_KEY_ID"),
      secret_access_key: System.fetch_env!("AWS_SECRET_ACCESS_KEY")
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, @s3_bucket,
        key: filename(entry),
        content_type: entry.client_type,
        max_file_size: socket.assigns.uploads.photos.max_file_size,
        expires_in: :timer.hours(1)
      )

    metadata = %{
      uploader: "S3",
      key: filename(entry),
      url: @s3_url,
      fields: fields
    }

    {:ok, metadata, socket}
  end

  defp filename(entry) do
    "#{entry.uuid}-#{String.replace(entry.client_name, " ", "_")}"
  end
end
