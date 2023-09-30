function toggle(){
    console.log("dropdown");
    element = document.getElementById("myDropdown").classList.toggle("invisible");
  }
  document.addEventListener("click", function(event) {
              var dropdown = document.querySelector(".dropdownlist");
              var dropButton = document.querySelector(".drop-button");

              if (dropdown && !dropdown.contains(event.target) && !dropButton.contains(event.target)) {
                      if (!dropdown.classList.contains('invisible')) {
                      dropdown.classList.add('invisible');
          }
  }
});