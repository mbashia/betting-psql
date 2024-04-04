defmodule BettingSystemWeb.UserLive.ViewUserComponent do
  use BettingSystemWeb, :live_component
  # alias  BettingSystem.Accounts.User
  alias BettingSystem.Users
  alias Phoenix.LiveView.JS
  alias BettingSystem.Bet

  def render(assigns) do
    ~H"""
    <div id="myModal" class="modal">
      <div class="modal-content pt-12 ">
        <div class="w-[100%] p-4 flex justify-between md:flex-row flex-col items-center gap-6 md:items-start">
          <div class="md:w-[25%]  w-[100%] flex flex-col justify-center items-center">
            <img
              src={@user_to_view.image}
              alt=""
              class="w-[150px] h-[150px] my-2 object-cover rounded-full"
            />

            <%= if @user_to_view.status == "active" do %>
              <button
                phx-click="soft_delete"
                phx-value-id={@user_to_view.id}
                phx-target={@myself}
                data-confirm="Are you sure you?"
                class="w-[200px] h-[48px]   mt-[20px] py-[10px] bg-red-500 mont-700 text-white rounded-3xl"
              >
                Deactivate
              </button>
            <% else %>
              <button
                phx-click="soft_delete"
                phx-value-id={@user_to_view.id}
                phx-target={@myself}
                data-confirm="Are you sure you?"
                class="w-[200px] h-[48px]  mt-[20px]  py-[10px] bg-green-500 mont-700 text-white rounded-3xl"
              >
                Activate
              </button>
            <% end %>
          </div>
          <div class="md:w-[70%] w-[100%] flex flex-col gap-4 shadow-md bg-[#202941] p-4 rounded-md shadow-[#000000]/40 ">
            <div class="flex flex-col gap-2">
              <p class="text-[#707070]  mont-500">
                Firstname
              </p>
              <div class="text-[#707070]">
                <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                  <%= @user_to_view.firstname %>
                </div>
              </div>
            </div>
            <div class="flex flex-col gap-2">
              <p class="text-[#707070]  mont-500">
                Lastname
              </p>
              <div class="text-[#707070]">
                <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                  <%= @user_to_view.lastname %>
                </div>
              </div>
            </div>

            <div class="flex w-[100%]  md:flex-row flex-col  justify-between  gap-2">
              <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                <p class="text-[#707070]  mont-500">
                  Email
                </p>
                <div class=" text-[#707070]">
                  <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                    <%= @user_to_view.email %>
                  </div>
                </div>
              </div>

              <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                <p class="text-[#707070]  mont-500">
                  Phone Number
                </p>
                <div class="text-[#707070]">
                  <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                    <%= @user_to_view.phone_number %>
                  </div>
                </div>
              </div>
            </div>
            <div class="flex w-[100%]  md:flex-row flex-col  justify-between  gap-2">
              <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                <p class="text-[#707070]  mont-500">
                  Dob
                </p>
                <div class=" text-[#707070]">
                  <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                    <%= @user_to_view.dob %>
                  </div>
                </div>
              </div>

              <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                <p class="text-[#707070]  mont-500">
                  Age
                </p>
                <div class="text-[#707070]">
                  <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                    <%= @user_to_view.phone_number %>
                  </div>
                </div>
              </div>
            </div>

            <div class="flex w-[100%]  md:flex-row flex-col  justify-between  gap-2">
              <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                <p class="text-[#707070]  mont-500">
                  Current Role
                </p>
                <div class=" text-[#707070]">
                  <div class="mont-500 w-[100%] bg-[#EBEBEB] focus:border-gray-800 focus:ring-gray-800 border-0 rounded-md p-3">
                    <%= @user_to_view.role %>
                  </div>
                </div>
              </div>
              <%= if @user.role == "SuperAdmin" do %>
                <div class="flex md:w-[48%] w-[100%] flex-col gap-2">
                  <p class="text-[#707070]  mont-500">
                    Change role
                  </p>
                  <div class="text-[#707070]">
                    <.form
                      let={f}
                      for={%{}}
                      id="role-form"
                      class="w-[100%]"
                      phx-target={@myself}
                      data-confirm="Are you sure you want to update role?"
                      phx-change="change_role"
                    >
                      <%= select(
                        f,
                        :role,
                        [{"Admin", "Admin"}, {"SuperAdmin", "SuperAdmin"}, {"User", "user"}],
                        class:
                          "hover:cursor-pointer border-none rounded-md flex items-center justify-center mont-600  py-2   text-[#2B6777] w-[100%]  mont-600 text-center",
                        prompt: "Set Role"
                      ) %>
                    </.form>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        </div>

        <div class="w-[100%] overflow-y-scroll flex justify-center items-center">
          <%= live_redirect(to: Routes.bets_index_path(@socket,:index,@user_to_view.id) )do %>
            <button class="w-[200px] h-[48px]   mt-[20px] py-[10px] bg-[#2B6777] mont-700 text-white rounded-3xl">
              View Bets
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("soft_delete", %{"id" => id}, socket) do
    user = Users.get_user!(id)

    cond do
      user.status == "active" ->
        case Users.update_user(user, %{status: "inactive"}) do
          {:ok, user} ->
            {:noreply,
             socket
             |> put_flash(:info, "User deactivated successfully")
             |> assign(:user_to_view, user)}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(:error, "Failed to deactivate user")}
        end

      user.status == "inactive" ->
        case Users.update_user(user, %{status: "active"}) do
          {:ok, user} ->
            {:noreply,
             socket
             |> put_flash(:info, "User activated successfully")
             |> assign(:user_to_view, user)}

          {:error, _changeset} ->
            {:noreply,
             socket
             |> put_flash(:error, "Failed to activate user:")}
        end

      true ->
        socket
        |> put_flash(:error, "Invalid user status")
    end
  end

  def handle_event("change_role", %{"role" => role}, socket) do
    change_params = %{"role" => role}

    case Users.update_user(socket.assigns.user_to_view, change_params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:user_to_view, user)
         |> put_flash(:info, "User role updated to #{role}")}

      {:error, _reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "User role not updated ")}
    end
  end
end
