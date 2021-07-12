// From cfx-keks
/*var count = 0;
var thisCount = 0;


const handlers = {
    startInitFunctionOrder(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += [data.type][data.order - 1] || '';
    },

    initFunctionInvoking(data) {
        document.querySelector('.yeet').style.left = '0%';
        document.querySelector('.yeet').style.width = ((data.idx / count) * 100) + '%';
    },

    startDataFileEntries(data) {
        count = data.count;

        document.querySelector('.letni h3').innerHTML += "\u{1f358}";
    },

    performMapLoadFunction(data) {
        ++thisCount;

        document.querySelector('.yeet').style.left = '0%';
        document.querySelector('.yeet').style.width = ((thisCount / count) * 100) + '%';
    },

    onLogLine(data) {
        document.querySelector('.letni p').innerHTML = data.message + "..!";
    }
};

window.addEventListener('message', function (e) {
    (handlers[e.data.eventName] || function () { })(e.data);
});
*/
/////////////////////////////////////////////

//
var lib =
{
    rand: function (min, max) {
        return min + Math.floor(Math.random() * max);
    },

    fadeInOut: function (duration, elementId, min, max) {
        var halfDuration = duration / 2;

        setTimeout(function () {
            var element = document.getElementById(elementId);
            element.style.opacity = min;

            setTimeout(function () {
                element.style.opacity = max;

            }, halfDuration);

        }, halfDuration);
    },
}
