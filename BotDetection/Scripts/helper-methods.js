//Formatting the date for text output
function parseDate(input) {
    var date = new Date(input);
    var output = date.getHours() + " hour(s), " + date.getMinutes() + " minute(s), " + date.getSeconds() + "second(s)";
    return output;
}
//Convert a ms date to days, hours mins etc...
function convertMS(milliseconds) {
    var day, hour, minute, seconds;
    if (milliseconds < 636150829400 && milliseconds > 0) {

        seconds = Math.floor(milliseconds / 1000);
        minute = Math.floor(seconds / 60);
        seconds = seconds % 60;
        hour = Math.floor(minute / 60);
        minute = minute % 60;
        day = Math.floor(hour / 24);
        hour = hour % 24;
    }
    else {
        seconds = 0;
        minute = 0;
        hour = 0;
        day = 999999;
    }
    return {
        day: day,
        hour: hour,
        minute: minute,
        seconds: seconds
    };
}
//return the day of the week +1 (1-7)
function checkDay(date) {
    return date.getDay() + 1;
}
//return the hour of the day +1 (to make it between 1-24)
function checkHour() {
    return date.getHours() + 1;
}
//Create 2D array
function createArray(length) {
    var arr = new Array(length || 0),
        i = length;

    if (arguments.length > 1) {
        var args = Array.prototype.slice.call(arguments, 1);
        while (i--) arr[length - 1 - i] = createArray.apply(this, args);
    }

    return arr;
}