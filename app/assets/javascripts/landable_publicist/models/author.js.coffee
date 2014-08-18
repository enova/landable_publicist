Publicist.Author = DS.Model.extend(
  username:   DS.attr()
  email:      DS.attr()
  firstName: DS.attr()
  lastName:  DS.attr()

  fullName: (->
    "#{@get('firstName')} #{@get('lastName')}"
  ).property('firstName', 'lastName')
)
