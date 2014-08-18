Publicist.QRCodeView = Ember.View.extend

  classNames: ['qr-code']

  didInsertElement: -> @generateCode()

  generateCode: (->
    # allow us to reuse the same view, swapping out the value
    @$().empty()

    new QRCode @get('element'),
      text: @get('value')
      width: 256
  ).observes('value')
