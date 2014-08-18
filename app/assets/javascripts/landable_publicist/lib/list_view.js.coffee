Publicist.ListViewController = Ember.ObjectController.extend
  listingHeight: 400

  filters: Ember.Object.create
    category: null
    isDeactivated: false
    isMissing: false
    isOkay: true
    isRedirect: true
    theme: null
    auditFlag: null
