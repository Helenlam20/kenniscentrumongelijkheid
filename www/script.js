
// Hardcoded way to collapse groene groep when OnePlot is selected
// Get collapse button from groene groep box
var box_btn = document.getElementById('box_groene_group').closest('.box').getElementsByClassName('btn btn-box-tool')[0];
// Hide the button
box_btn.style.visibility='hidden';
// Add an listener to the OnePlot toggle to also click the hidden collapse button
document.getElementById('OnePlot').addEventListener('change', function(){box_btn.click()});

// Hide the alterative plot button
document.getElementById('change_barplot').closest('div').style.display='none';

// Limit the maximum aspect ratio of the body on ultra-wide monitors to ~16:9
function limit_body_width() {
    let max_width = Math.max(1920, Math.round(1.8*window.screen.height));
    document.body.style.maxWidth = `${max_width}px`;
}

limit_body_width();
window.addEventListener("resize", limit_body_width);


// Hacky way to add fire an shiny event when it is in a mobile state
var is_mobile = true;
function check_mobile() {
    let is_mobile_new = document.getElementById("sidebarCollapsed").getAttribute("data-collapsed");
    if (is_mobile != is_mobile_new) {
        is_mobile = is_mobile_new;
        try{
            Shiny.setInputValue("hide_legend", is_mobile);
        } catch(e) {
            // Hacky way to fire the event again if in mobile and Shiny.setInputValue hasn't loaded yet
            is_mobile = true;
        }
    }
}

const sidebar = document.getElementById("sidebarCollapsed");
const observer = new MutationObserver(check_mobile);
observer.observe(sidebar, {attributes: true})
