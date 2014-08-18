Publicist.Select = Ember.View.extend

  classNames: ['publicist-select']

  optionValuePath: 'content.value'
  optionLabelPath: 'content.label'

  content: null
  prompt: null
  value: null
  selection: null

  selectionLabel: (->
    if @get('selection')
      selection = @get('selection')
      if typeof selection == 'string'
        selection
      else
        Ember.get(selection, @get('optionLabelPath').replace(/^content\./, ''))
    else
      @get('prompt')
  ).property('selection')

  template: Ember.Handlebars.compile """
    <label>
      <span>{{view.selectionLabel}}</span>
      <i class="fa fa-angle-down"></i>
      {{view view.selectView viewBinding="view"}}
    </label>
  """

  # passthrough to apply the select element id, since binding doesn't fly here
  selectElementId: ((key, value) ->
    if arguments.length > 1
      @get('selectView').reopen(elementId: value)
  ).property()

  # create the subclass on demand, per instance
  selectView: (->
    Ember.Select.extend
      classBinding: 'view.selectClass'
      contentBinding: 'view.content'
      optionLabelPathBinding: 'view.optionLabelPath'
      optionValuePathBinding: 'view.optionValuePath'
      promptBinding: 'view.prompt'
      valueBinding: 'view.value'
      selectionBinding: 'view.selection'
  ).property()
