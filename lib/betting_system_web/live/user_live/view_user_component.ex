defmodule BettingSystemWeb.UserLive.ViewUserComponent do
  use BettingSystemWeb, :live_component
  # alias  BettingSystem.Accounts.User
  alias BettingSystem.Users

  def render(assigns) do
    ~H"""
    <div id="myModal" class="modal">
      <div class="modal-content pt-12 ">
        this is the view user
      </div>
    </div>
    """
  end
end
