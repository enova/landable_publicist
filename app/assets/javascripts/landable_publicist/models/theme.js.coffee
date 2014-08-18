Publicist.Theme = DS.Model.extend
  body:         DS.attr('string', defaultValue: """
    <!DOCTYPE html>
    <html>
      <head>
        {% head %}
      </head>
      <body>{% body %}</body>
    </html>
  """)
  deletedAt:    DS.attr('string')
  description:  DS.attr()
  editable:     DS.attr('boolean', readOnly: true)
  isEditable:   Ember.computed.alias('editable')
  name:         DS.attr()
  thumbnailUrl: DS.attr()

  isDeactivated: (-> !!@get('deletedAt')).property('deletedAt')

Publicist.Theme.reopenClass
  availableTags: [
    Ember.Object.create(code: '{% body %}', description: 'The body of the displayed page'),
    Ember.Object.create(code: '{% head %}', description: 'The complete title tag, any configured meta tags, and any configured head tags'),
    Ember.Object.create(code: '{% title_tag %}', description: 'The complete title tag for the displayed page'),
    Ember.Object.create(code: '{% meta_tags %}', description: 'Any configured meta tags (e.g. robots, keywords, descriptions)'),
    Ember.Object.create(code: '{% head_content %}', description: "Any configured head tags (e.g. <head lang='en'>)")
  ]
