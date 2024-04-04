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
                      id="search-form"
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

        <div>
          <span>View Bets</span>
          <%= for bet <-  @bets do %>
            <div class="p-4 w-[100%] text-white poppins-regular border-[1px] border-gray-700 ">
              <p>bet id:#<%= bet.bet_id %></p>
              <p>amount:<%= bet.amount %></p>
              <p>payout:<%= bet.payout %></p>
              <p style="color:brown;"><%= bet.status %></p>
              <p>result:<%= bet.end_result %></p>
              <p>profit:<%= get_profit(bet.bet_id) %></p>

              <button
                class="mont-600 text-lg hover:cursor-pointer"
                phx-click={
                  JS.toggle(to: "#item#{bet.id}", in: "fade-in-scale", out: "fade-out-scale")
                }
              >
                View Bet Items
              </button>

              <div id={"item#{bet.id}"} class="hidden">
                <table class=" p-2 w-auto md:w-[100%]">
                  <thead class="border-b-2 poppins-regular border-black">
                    <tr>
                      <th class="p-2 font-semibold ">Odds</th>

                      <th class="p-2 font-semibold ">Game_id</th>
                      <th class="p-2 font-semibold ">Prediction</th>

                      <th class="p-2 font-semibold ">Result</th>
                    </tr>
                  </thead>
                  <tbody id="events" class="poppins-light">
                    <%= for x <- get_games(bet.bet_id) do %>
                      <tr
                        class="border-b-[1px] cursor-pointer text-center hover:bg-blue-100/50 transition-all ease-in-out duration-500  border-black"
                        id={"x-#{x.id}"}
                      >
                        <td class="text-sm md:text-base p-2">
                          <div class="flex fex-col justify-center items-center">
                            <img
                              src="/images/champe_no_bc.png"
                              class="w-[50px] h-[50px] object-cover "
                            />
                          </div>
                        </td>
                        <td class="text-sm md:text-base "><%= x.odds %></td>

                        <td class="text-sm md:text-base"><%= x.game_id %></td>
                        <td class="text-sm md:text-base"><%= x.result_type %></td>

                        <td class="text-sm md:text-base"><%= x.end_result %></td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
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

  def get_games(betid) do
    Bet.get_all_betslips_in_bet(betid)
  end

  def get_profit(betid) do
    bet = Bet.get_bet_by_betid(betid)

    case bet.end_result do
      "won" -> "loss" <> bet.payout
      "lost" -> "profit" <> bet.payout
      "nothing" -> "Not Over Yet"
    end
  end
end
