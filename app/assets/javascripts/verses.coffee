# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.App ||= {}

selected_verses = []
selected_excerpt_id = null

pluck = (arr, prop)->
  $.map arr, (o)->
    return o[prop]

class TagsInExcerpt
  constructor: ()->
    $(window.App).bind('excerpts:selected', @update)
    $(window.App).bind('excerpts:unselected', @update)
    $(window.App).bind('selected_verses:changed', @update)

  update: ()=>
    console.log('selected_excerpt_id', selected_excerpt_id)
    if selected_excerpt_id is null
      $('.js-list-tags-in-excerpt').html("<i>Please select an excerpt</i>")
    else
      $.get "/excerpts/#{selected_excerpt_id}/tags", (data) ->
        $('.js-list-tags-in-excerpt').html(data.map((tag)-> "<a href='/tags/#{tag.id}/show'>#{tag.name}</a>").join(' '))
        select = $('.js-excerpt-edit__tags')
        select.find('option').each ()->
          if $.inArray($(this).val(), pluck(data, 'name')) != -1
            $(this).prop('selected', true)
        select.trigger('chosen:updated')
      $.get "/excerpts/#{selected_excerpt_id}/note", (data) ->
        $('.js-excerpt-edit__note').val(data)
    if selected_verses.length > 0
      $('.js-assign-tag-to-verses').show()
    else
      console.log('NE PAS montrer la note')

class Excerpts
  constructor: ()->
    $('.js-chapter-content').on 'click', '.js-excerpt-start, .js-excerpt-end', (e)=>
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
  constructor: (@book_number, @chapter_number, @verse_numbers)->
    @jq_element = $('.js-excerpt-edit')
    select = @jq_element.find('.js-excerpt-edit__tags')
    select.chosen()
    # $('.js-assign-tag-to-verses').hide() # by default it's hidden

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
    $(window.App).bind('excerpts:selected', @toggle)
    $(window.App).bind('excerpts:unselected', @toggle)

  init_events: ()->
    form = $('.js-excerpt-note-edit')
    $('.js-excerpt-note-edit').on 'submit', (e)=>
      e.preventDefault()
      console.log('submit')
      tags = form.find('.js-excerpt-edit__tags').val()
      book = form.find('.js-excerpt-edit__book').val()
      chapter = form.find('.js-excerpt-edit__chapter').val()
      verses = form.find('.js-excerpt-edit__preview').text().split(', ')
      note = form.find('.js-excerpt-edit__note').val()
      console.log('tags', tags, 'verses', verses)
      post_data = {tags: tags, book: book, chapter: chapter, verses: verses, excerpt_id: selected_excerpt_id}
      if note isnt ''
        post_data['note'] = note
      $.post $(e.target).attr('action'), post_data,
        ((data, textStatus, jqXHR)=> $(window.App).trigger('excerpt:created'))
    $('.js-excerpt-delete').on 'click', (e)=>
      e.preventDefault()
      $.post "/excerpts/#{selected_excerpt_id}/delete", (data)=>
        $(window.App).trigger('excerpt:deleted')
        console.log('data', data)

  handle_selected_verses: ()=>
    console.log('handle selected verse')
    $('.js-excerpt-edit__preview').text(selected_verses.sort((a,b)-> a - b).join(', '))

  toggle: ()=>
    if selected_excerpt_id is null
      console.log('nothing selected')
      $('.js-excerpts-edit-box').hide()
      $('.js-tags-in-excerpt').hide()
      $('.js-note-edit-box').hide()
    else
      console.log('something selected')
      $('.js-excerpts-edit-box').show()
      $('.js-tags-in-excerpt').show()
      $('.js-note-edit-box').show()

class Highlights
  constructor: ()->
    console.log('highlight')
    $(window.App).bind('selected_verses:changed', @handle_selected_verses)
    $(window.App).bind('excerpt:created', @handle_excerpt_created)
    $('.js-chapter-content').on 'click', '.js-verse__text', (e)-> $(this).prev('sup').find('.js-verse__number').triggerHandler('click')
    @init_click()

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
    select = $('.js-excerpt-edit__tags')
    select.find('option').each ()->
      $(this).prop('selected', false)
    select.trigger('chosen:updated')
    $('.js-excerpt-edit__note').val('')

  init_click: ()->
    $('.js-chapter-content').on 'click', '.js-verse__number', (e)->
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
      # console.log('verse', $(this).data('version_slug'), $(this).data('book_number'), $(this).data('chapter_number'), $(this).data('verse_number'))

class Chapter
  constructor: (@book_number, @chapter_number) ->
    $(window.App).bind('excerpt:created', @update)
    $(window.App).bind('excerpt:deleted', @update)

  update: (e)=>
    versions_suffix = if $('.js-versions').length > 0 then "?versions=#{$('.js-versions').val()}" else ""
    $.get "/book/#{@book_number}/chapters/#{@chapter_number}/chapter_only#{versions_suffix}", (data) ->
      $('.js-chapter-content').html(data)

class App.Verses
  constructor: (book_number, chapter_number)->
    excerptEditor = new ExcerptEdit()
    highlights = new Highlights()
    excerpts = new Excerpts()
    tags_in_excerpt = new TagsInExcerpt()
    chapter = new Chapter(book_number, chapter_number)
