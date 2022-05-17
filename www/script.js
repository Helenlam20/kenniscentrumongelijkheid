
// Hardcoded way to collapse groene groep when OnePlot is selected
// Get collapse button from groene groep box
var box_btn = document.getElementById('box_groene_group').closest('.box').getElementsByClassName('btn btn-box-tool')[0];
// Hide the button
box_btn.style.visibility='hidden';
// Add an listener to the OnePlot toggle to also click the hidden collapse button
document.getElementById('OnePlot').addEventListener('change', function(){box_btn.click()})



// Hide barplot button
document.getElementById("change_barplot").style.visibility='hidden';