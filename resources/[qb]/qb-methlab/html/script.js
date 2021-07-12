Laptop = {}

$(document).ready(function(){
    window.addEventListener('message', function(event){
        var action = event.data.action;

        switch(action){
            case "open":
                Laptop.Open(event.data);
                break;
        }
    });
});

$(document).on('keydown', function() {
    switch(event.keyCode) {
        case 27:
            Laptop.Close();
            break;
    }
});

Laptop.Open = function(data) {
    $(".methlab-tasks").html("");
    $.each(data.tasks, function(i, task){
        var Completed = '<i class="fas fa-times">';
        if (task.completed) {
            Completed = '<i class="fas fa-check">';
        }
        var elem = '<div class="methlab-task" data-task="' + (i + 1) + '"> <div class="methlab-task-label">Stap ' + (i + 1) + ': ' + task.label + '</div> <div class="methlab-task-completed">Voltooid: ' + Completed + '</i></div> </div>';
        $(".methlab-tasks").append(elem);
    });
    $(".container").fadeIn(150);
}

Laptop.Close = function() {
    $(".container").fadeOut(150);
    $.post('https://qb-methlab/Close');
}