$(function () {
    const OpenDialoge = () => {
      $('#picker').addClass('show').addClass('active');
      $('#closeWindow').css({"display":"none"})
      $('#staticBackdrop').modal('toggle');
      $('#confirmColour').fadeIn(500);
      $('#closeWindow').fadeIn(500);
    }

    //OpenDialoge();

    $('#primary').colorpicker({
      useAlpha: false,
      customClass: 'colorpicker-2x',
      sliders: {
        saturation: {
          maxLeft: 200,
          maxTop: 200
        },
        hue: {
          maxTop: 200
        },
        alpha: {
          maxTop: 200
        }
      }
    });

    $('#secondary').colorpicker({
      useAlpha: false,
      customClass: 'colorpicker-2x',
      sliders: {
        saturation: {
          maxLeft: 200,
          maxTop: 200
        },
        hue: {
          maxTop: 200
        },
        alpha: {
          maxTop: 200
        }
      }
    });
    
    
    $('#confirmColour').on('click', () => {
      let primary = $("#primary").val()
      primary = primary.substring(4, primary.length-1).replace(/ /g, '').split(',');
      let secondary = $("#secondary").val()
      secondary = secondary.substring(4, secondary.length-1).replace(/ /g, '').split(',');
      let vehicleList = $("#message-text").val().split(", ");

      //console.log(primary, secondary, vehicleList)
      $.post(`https://${GetParentResourceName()}/SetVehicleColour`, JSON.stringify({primary: primary, secondary: secondary, vehicleList: vehicleList}));
    });

    $('#closeWindow').on('click', () => {
      $.post(`https://${GetParentResourceName()}/CloseMenu`)
    })

    $('#primary').on("colorpickerUpdate", (event) => {
      $("#primary").css("background-color", event.color.toString());
    });
    $('#secondary').on("colorpickerUpdate", (event) => {
      $("#secondary").css("background-color", event.color.toString());
    });

    window.addEventListener("message", function (event) {
      if (event.data.action == "open") { OpenDialoge() } 
    });
  });