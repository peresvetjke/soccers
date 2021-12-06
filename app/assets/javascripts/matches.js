document.addEventListener("turbolinks:load", () => {  
  $(".search_matches form").on('ajax:success', function(e) {
    var template = _.template("<tr><td><%= league_title %></td><td><%= date_time %></td><td><%= home_team_title %></td><td><%= score_home %> : <%= score_away %></td><td><%= away_team_title %></td></tr>");
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

})