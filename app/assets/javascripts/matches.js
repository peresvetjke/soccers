document.addEventListener("turbolinks:load", () => {  

  var track_links   = document.querySelectorAll('.matches .track a')
  var untrack_links = document.querySelectorAll('.matches .untrack a')

  if (track_links.length) {
    for (var i = 0; i < track_links.length; i++) {
      track_links[i].addEventListener('click', trackButtonHandler);  
    }
  }

  if (untrack_links.length) {
    for (var i = 0; i < untrack_links.length; i++) {
      untrack_links[i].addEventListener('click', trackButtonHandler);  
    }
  }

  function trackButtonHandler(event) {
    var matchId = this.dataset.itemId;
    trackFormHandler(matchId)
  }

  function trackFormHandler(matchId) {
    var trackButton = document.body.querySelector(`tr[item-id="${matchId}"] .track`)
    var untrackButton = document.body.querySelector(`tr[item-id="${matchId}"] .untrack`)
    if (trackButton.classList.contains('hide')) {
      trackButton.classList.remove('hide');
      untrackButton.classList.add('hide');
    } else {
      trackButton.classList.add('hide');
      untrackButton.classList.remove('hide');
    }
  }
})

/*
  // Most people bind JQuery to elements directly; this binding only happens on DOM load, meaning any new elements have no functions attached to them:
  // https://stackoverflow.com/questions/34478054/rails-ajax-submit-doesnt-work-without-reload
  $(".matches .track form").on('ajax:success', function(e) {
  track_buttons.on('ajax:success', function(e) {
    console.log("Put on track!")
    var match = e.detail[0]
    $(`.matches tr[item-id=${match.id}] .track`).toggle()
    $(`.matches tr[item-id=${match.id}] .untrack`).toggle()
  })
    .on('ajax:error', function (e) {
      console.log('oshibochka')
    })

  track_buttons.on('ajax:success', function(e) {
    var match = e.detail[0]
    console.log("Dropped from track!")
    $(`.matches tr[item-id=${match.id}] .track`).toggle()
    $(`.matches tr[item-id=${match.id}] .untrack`).toggle()
  })
    .on('ajax:error', function (e) {
      console.log('oshibochka')
    })


  $(".search_matches form").on('ajax:success', function(e) {
*/
/*
    var template = _.template("<tr><td><%= league_title %></td><td><%= date_time %></td><td><%= home_team_title %></td><td><%= score_home %> : <%= score_away %></td><td><%= away_team_title %></td><td><%= button_to 'test' %></td></tr>");
    var matches = e.detail[0]
    
    $(".matches tbody tr").remove()
    matches.forEach(element => {
        var match = template({league_title: element.league_title, date_time: element.date_time, home_team_title: element.home_team_title, score_home: element.score_home, score_away: element.score_away, away_team_title: element.away_team_title})
        $(".matches tbody").append(match)
      });

  }) 
    .on('ajax:error', function (e) {
      console.log('oshibochka')
    })
*/

