$(document).ready(function() {
    window.addEventListener('message', function(event) {
        if (event.data.openModeSelector == "show") {
            var div = document.getElementById("ui_joinffa_container");
            div.style.display = "block";
            document.getElementById("ui_joinffa_area2_playercount").innerHTML = event.data.smgZonePlayerCount;
            document.getElementById("ui_joinffa_area1_playercount").innerHTML = event.data.pistolZonePlayerCount;
            document.getElementById("ui_joinffa_area3_playercount").innerHTML = event.data.rifleZonePlayerCount;
        }
        else if (event.data.openHud == "show") 
        {
            document.getElementById("hud").style.display = "flex";
            document.getElementById("ffa").style.display = "block";
            document.getElementById("keybind_hud").style.display = "block";
            CloseUI()
        }
        else if (event.data.openLeaderBoard == "show") 
        {
            document.getElementById("ui_leaderboard_menu").style.display = "flex";
            updateUserbox(event.data.scoreBoardData);
        } 
        else if (event.data.closeHud == true) 
        {
            document.getElementById("hud").style.display = "none";
            document.getElementById("ffa").style.display = "none";
            document.getElementById("keybind_hud").style.display = "none";
            document.getElementById("ui_u_are_in_the_edit_mode").style.display = "none";
            
            CloseUI()
        } 
        else if (event.data.editMode == true) 
        {
            document.getElementById("hud").style.cursor = "move";
            document.getElementById("ffa").style.cursor = "move";
            document.getElementById("keybind_hud").style.cursor = "move";
            document.getElementById("ui_u_are_in_the_edit_mode").style.display = "flex";
            dragElement(document.getElementById("hud"));
            dragElement(document.getElementById("ffa"));
            dragElement(document.getElementById("keybind_hud"));
            // document.getElementById("hud").style. = "move";
            
        } 
        else if (event.data.resetEdits == true) 
        {
            resetPosition(document.getElementById("hud"), "49.829166666666666vw", "84.28802083333333vw");
            resetPosition(document.getElementById("ffa"), "41.25vw", "89.73958333333333vw");
            resetPosition(document.getElementById("keybind_hud"), "30.833333333333336vw", "0.5208333333333333vw");
        }
        else if (event.data.updatePlyHudData == true) 
        {
            document.getElementById("kill").innerHTML = event.data.sendPlyKills;
            document.getElementById("death").innerHTML = event.data.sendPlyDeaths;
            document.getElementById("kd").innerHTML = event.data.sendKD;
        }

    });

    document.getElementById("ui_joinffa_area1_joinbutton").onclick = function() {
        $.post("https://f4st-ffa/JoinArea1");
    };

    document.getElementById("ui_joinffa_area2_joinbutton").onclick = function() {
        $.post("https://f4st-ffa/JoinArea2");
    };

    document.getElementById("ui_joinffa_area3_joinbutton").onclick = function() {
        $.post("https://f4st-ffa/JoinArea3");
    };

    document.getElementById("ui_leaderboard_exitffa").onclick = function() {
        // console.log("Exit button triggered")
        $.post("https://f4st-ffa/ExitZone");
    };
 
    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            CloseUI()
        }
    });
    
    function CloseUI() {
        document.getElementById("ui_joinffa_container").style.display = "none";
        document.getElementById("ui_leaderboard_menu").style.display = "none";
        document.getElementById("ui_u_are_in_the_edit_mode").style.display = "none";
        $.post("https://f4st-ffa/closeUI");
    }   
});


function resetPosition(elmnt, data, data2) {
    elmnt.style.top = data;
    elmnt.style.left = data2;
}

function dragElement(elmnt) {
    var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
    
    if (document.getElementById(elmnt.id + "header")) {
      document.getElementById(elmnt.id + "header").onmousedown = dragMouseDown;
    } else {
      elmnt.onmousedown = dragMouseDown;
    }
  
    function dragMouseDown(e) {
      e = e || window.event;
      e.preventDefault();
      pos3 = e.clientX;
      pos4 = e.clientY;
      document.onmouseup = closeDragElement;
      document.onmousemove = elementDrag;
    }
  
    function elementDrag(e) {
      e = e || window.event;
      e.preventDefault();
      var newPosX = e.clientX;
      var newPosY = e.clientY;
      pos1 = pos3 - newPosX;
      pos2 = pos4 - newPosY;
      pos3 = newPosX;
      pos4 = newPosY;
  

      var newLeft = (elmnt.offsetLeft - pos1) / window.innerWidth * 100;
      var newTop = (elmnt.offsetTop - pos2) / window.innerHeight * 100;
  
      elmnt.style.left = newLeft + "vw";
      elmnt.style.top = newTop + "vh";
    }
  
    function closeDragElement() {
      document.onmouseup = null;
      document.onmousemove = null;
    }
  }
  

console.log("Fast Scripts / f4st-ffa")


function updateUserbox(users) {
    const userbox = document.querySelector('.ui_leaderboard_userbox');
    // console.log(userbox);
    userbox.innerHTML = ''; 

    
    users.forEach((user, index) => {
        const userItem = document.createElement('div');
        userItem.className = 'ui_leaderboard_user_one';
        
        const userName = document.createElement('div');
        userName.className = 'ui_leaderboard_user_one_ply_name';
        userName.textContent = `${index + 1} • ${user.name}`;
        
        const userKd = document.createElement('div');
        userKd.className = 'ui_leaderboard_user_one_ply_kd';
        userKd.textContent = user.kd;
        
        userItem.appendChild(userName);
        userItem.appendChild(userKd);
        userbox.appendChild(userItem);
    });
}

