defmodule TimeManagerWeb.ErrorJSON do
  @moduledoc """
  Handles rendering of error messages in JSON format.
  """

  def render("404.json", _assigns) do
    %{errors: %{detail: "Not Found"}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  def error(%{message: message}) do
    %{errors: %{detail: message}}
  end

  def error(%{status: :unauthorized}) do
    %{
      errors: %{detail: "Unauthorized access"}
    }
  end

  def error(%{status: :forbidden}) do
    %{
      errors: %{detail: "Access forbidden"}
    }
  end

  def error(%{status: :not_found}) do
    %{
      errors: %{detail: "Resource not found"}
    }
  end

  def error(%{status: :bad_request}) do
    %{
      errors: %{detail: "Bad request"}
    }
  end

  # Add clauses for other common statuses as necessary

  # Fallback if the status is not specifically handled
  def error(%{status: status}) do
    %{
      errors: %{detail: "An error occurred: #{inspect(status)}"}
    }
  end

end
