
// Hardcoded way to collapse groene groep when OnePlot is selected
// Get collapse button from groene groep box
var box_btn = document.getElementById('box_groene_group').closest('.box').getElementsByClassName('btn btn-box-tool')[0];
// Hide the button
box_btn.style.visibility='hidden';
// Add an listener to the OnePlot toggle to also click the hidden collapse button
document.getElementById('OnePlot').addEventListener('change', function(){
    document.getElementById('OnePlot').disabled=true;
    box_btn.click();
    $(document).one('shiny:idle', function() {
        document.getElementById('OnePlot').disabled=false;
    })
});

// Hide the alterative plot button
document.getElementById('change_barplot').closest('div').style.display='none';


// Disable Alternative plot button when shiny is busy with the plot
document.getElementById('change_barplot').addEventListener('change', function(){
    document.getElementById('change_barplot').disabled=true;
    $(document).one('shiny:idle', function() {
        document.getElementById('change_barplot').disabled=false;
    })
});

// Disable reset button when shiny is busy with the plot
document.getElementById('user_reset').addEventListener('click', function(){
    document.getElementById('user_reset').disabled=true;
    $(document).one('shiny:idle', function() {
        document.getElementById('user_reset').disabled=false;
    })
});


// Limit the maximum aspect ratio of the body on ultra-wide monitors to ~16:9
function limit_body_width() {
    let max_width = Math.max(1920, Math.round(1.8*window.screen.height));
    document.body.style.maxWidth = `${max_width}px`;
}

limit_body_width();
window.addEventListener("resize", limit_body_width);


// Hacky way to add fire an shiny event when it is in a mobile state
function check_mobile() {
    let is_mobile = document.getElementById("sidebarCollapsed").getAttribute("data-collapsed");
    try{
        Shiny.setInputValue("hide_legend", is_mobile);
    } catch(e) {}
}

const sidebar = document.getElementById("sidebarCollapsed");
const sidebar_observer = new MutationObserver(check_mobile);
sidebar_observer.observe(sidebar, {attributes: true})


// Add header click to FAQ boxes
let faq_boxes = document.getElementsByClassName("faq");
for (let faq_box of faq_boxes) {
    let header = faq_box.getElementsByClassName("box-header")[0];
    let collapse_btn = faq_box.getElementsByClassName("btn")[0];
    header.addEventListener("click", ()=>collapse_btn.click());
}

// Show beginscherm on first start
$(document).on('shiny:connected', function(){
    let user_visited = Cookies.get("user_visited");
    if(user_visited === undefined) {
        Shiny.setInputValue("beginscherm", true);
        Cookies.set("user_visited", true);
    }
})