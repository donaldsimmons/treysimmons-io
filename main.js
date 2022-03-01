'use strict';
function setYearsCounter(startDate) {
    let today = new Date();
    let yearsDiff = (Math.floor((today-startDate)/31556952000));
    document.getElementById('years-counter').textContent = yearsDiff + " years";
}

setYearsCounter(new Date('2013','09','15'));