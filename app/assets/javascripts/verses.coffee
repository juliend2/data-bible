# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.App ||= {}

selected_verses = []
selected_excerpt_id = null

class TagsInExcerpt
  constructor: ()->
    $(window.App).bind('excerpts:selected', @update)
    $(window.App).bind('excerpts:unselected', @update)

  update: ()=>
    console.log('selected_excerpt_id', selected_excerpt_id)
    if selected_excerpt_id is null
      $('.tags-in-excerpt').html("<i>Please select an excerpt</i>")
    else
      $.get "/excerpts/#{selected_excerpt_id}/tags", (data) ->
        $('.tags-in-excerpt').html(data.map((tag)-> "<a href='/tags/#{tag.id}/show'>#{tag.name}</a>").join(' '))

class Excerpts
  constructor: ()->
    @jq_elements = $('.js-excerpt-start, .js-excerpt-end')
    @jq_elements.on 'click', (e)=>
      e.preventDefault()
      id = $(e.target).data('excerpt_id')
      color = $(e.target).data('excerpt_color')
      @reset_all_colors()
      if selected_excerpt_id == id
        selected_excerpt_id = null
        $(window.App).trigger('excerpts:unselected')
      else
        selected_excerpt_id = id
        $(".js-in-excerpt-#{id}").css(backgroundColor: "##{color}")
        $(window.App).trigger('excerpts:selected')

  reset_all_colors: ()->
    $('.js-verse__text').css(backgroundColor: 'initial', color: 'black')

class ExcerptEdit
  constructor: (@version_slug, @book_number, @chapter_number, @verse_numbers)->
    @jq_element = $('.js-excerpt-edit')
    select = @jq_element.find('.js-excerpt-edit__tags')
    select.chosen()

    # Hack from: http://stackoverflow.com/a/24961779/242404
    select.next('.chosen-container').find('input').on 'keydown', (evt) ->
      # console.log('keyDown', evt.keyCode)
      _ref = evt.which
      stroke = if _ref isnt null then _ref else evt.keyCode
      if stroke is 188 # 9 is TAB, 188 is COMMA
        select.append('<option value="'+$(this).val()+'" selected="selected">'+$(this).val()+'</option>')
        select.trigger('chosen:updated')
        return false # prevent the comma from being inserted in the field

    $(window.App).bind('selected_verses:changed', @handle_selected_verses)
    @init_events()

  init_events: ()->
    @jq_element.on 'submit', (e)=>
      e.preventDefault()
      console.log('submit')
      tags = @jq_element.find('.js-excerpt-edit__tags').val()
      book = @jq_element.find('.js-excerpt-edit__book').val()
      chapter = @jq_element.find('.js-excerpt-edit__chapter').val()
      verses = @jq_element.find('.js-excerpt-edit__preview').text().split(', ')
      console.log('tags', tags, 'verses', verses)
      $.post $(e.target).attr('action'),
        {tags: tags, book: book, chapter: chapter, verses: verses},
        ((data, textStatus, jqXHR)=> $(window.App).trigger('excerpt:created'))
    $('.js-excerpt-delete').on 'click', (e)=>
      e.preventDefault()
      $.post "/excerpts/#{selected_excerpt_id}/delete", (data)=>
        console.log('data', data)

  handle_selected_verses: ()=>
    console.log('handle selected verse')
    $('.js-excerpt-edit__preview').text(selected_verses.sort((a,b)-> a - b).join(', '))

class Highlights
  constructor: ()->
    console.log('highlight')
    $(window.App).bind('selected_verses:changed', @handle_selected_verses)
    $(window.App).bind('excerpt:created', @handle_excerpt_created)
    $('.js-verse__text').on 'click', (e)-> $(this).prev('sup').find('.js-verse__number').triggerHandler('click')

  handle_selected_verses: ()=>
    console.log('handle selected verse')
    $('.js-verse').each ()->
      if selected_verses.indexOf($(this).find('.js-verse__number').data('verse_number')) isnt -1
        $(this).addClass('selected')
      else
        $(this).removeClass('selected')

  handle_excerpt_created: ()=>
    console.log('handle_excerpt_created')
    selected_verses = []
    $(window.App).trigger('selected_verses:changed')

class Verse
  constructor: (jq_element)->
    @jq_element = jq_element
    @init_click()

  init_click: ()->
    @jq_element.find('.js-verse__number').on 'click', (e)->
      e.preventDefault()
      if selected_verses.indexOf($(e.target).data('verse_number')) isnt -1
        console.log('selected')
        # unselect
        selected_verses.splice(selected_verses.indexOf($(e.target).data('verse_number')), 1)
      else
        console.log('NOT selected')
        # select
        selected_verses.push($(e.target).data('verse_number'))
      $(window.App).trigger('selected_verses:changed')
      console.log('verse', $(this).data('version_slug'), $(this).data('book_number'), $(this).data('chapter_number'), $(this).data('verse_number'))

class App.Verses
  constructor: ()->
    excerptEditor = new ExcerptEdit()
    highlights = new Highlights()
    excerpts = new Excerpts()
    tags_in_excerpt = new TagsInExcerpt()
    $('.js-verse').each ()->
      verse = new Verse($(this))
