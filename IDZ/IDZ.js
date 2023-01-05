{
    init: function(elevators, floors) {
        var call_array = [];
        
        elevators.forEach( function(elem) {
            elem.on("idle", function() {
                if(call_array.length > 0) {
                    var fl = call_array.shift();
                    elem.goToFloor(fl);
                }
            });
        });

        elevators.forEach( function(elem) {
            elem.on("floor_button_pressed", function(floorNum) {
                //elem.destinationQueue.push(floorNum);
                //elem.destinationQueue.sort();
                //elem.checkDestinationQueue();
                elem.goToFloor(floorNum);
            });
        });

        elevators.forEach( function(elem) {
            elem.on("stopped_at_floor", function(floorNum) {
                if(elem.loadFactor() < 0.25) {
                    elem.goingUpIndicator(true); elem.goingDownIndicator(true);
                }
                if(floorNum == 0) {
                    elem.goingUpIndicator(true); elem.goingDownIndicator(false);
                }
                if(floorNum == floors.length - 1) {
                    elem.goingUpIndicator(false); elem.goingDownIndicator(true);
                }
            })
        });

        elevators.forEach( function(elem) {
            elem.on("passing_floor", function(floorNum, direction) { 
                switch(direction) {
                    case "up":   elem.goingUpIndicator(true);  elem.goingDownIndicator(false); break;
                    case "down": elem.goingUpIndicator(false); elem.goingDownIndicator(true); break;
                }
                if(elem.loadFactor() != 1) {
                    if(floors[floorNum].buttonStates.up && direction == "up") {
                        elem.destinationQueue.unshift(floorNum);
                        elem.checkDestinationQueue();
                    }
                    if(floors[floorNum].buttonStates.down && direction == "down") {
                        elem.destinationQueue.unshift(floorNum);
                        elem.checkDestinationQueue();
                    }
                }
            });
        });
        
        floors.forEach( function(elem) {
            elem.on("up_button_pressed", function() {
                var done = false;
                
                elevators.forEach( function(el) {
                    if(el.destinationQueue.length == 0 && done == false) {
                        el.goToFloor(elem.floorNum());
                        done = true;
                    }
                })
                
                if (done == false) {
                    call_array.push(elem.floorNum())
                }
            })
        });
        
        floors.forEach( function(elem) {
            elem.on("down_button_pressed", function() {
                var done = false;

                elevators.forEach( function(el) {
                    if(el.destinationQueue.length == 0 && done == false) {
                        el.goToFloor(elem.floorNum());
                        done = true;
                    }
                })

                if (done == false) {
                    call_array.push(elem.floorNum())
                }
            })
        });

        },

        update: function(dt, elevators, floors) {
        }
}