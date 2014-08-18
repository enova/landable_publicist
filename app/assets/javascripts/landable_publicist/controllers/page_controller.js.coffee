# pages are more complicated than templates and themes. the other controllers
# for this resource are in ./page.

Publicist.PageController = Publicist.EditorController.extend
  parentRoute: 'directories'

  # convenience for the user - if there's a page body error, redirect to the
  # place where they will see and then resolve the error
  modelErrorObserver: (->
    if @get('model.errors.body')
      @transitionToRoute 'page.code'
  ).observes('model.isValid')

