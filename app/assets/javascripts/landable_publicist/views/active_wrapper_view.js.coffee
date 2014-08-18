# Wrapper view that has an "active" class based on its first child view's
# "active" property
Publicist.ActiveWrapperView = Ember.View.extend
  tagName: 'li'
  classNameBindings: 'active'

  active: (-> @get 'childViews.firstObject.active').property('childViews.firstObject.active')