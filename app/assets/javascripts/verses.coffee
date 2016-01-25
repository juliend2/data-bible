# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.App ||= {}

class Verse
  constructor: (jq_element)->
    @jq_element = jq_element
    @init_click()

  init_click: ()->
    @jq_element.find('.js-verse__number').on 'click', (e)->
      e.preventDefault()
      # console.log('verse clicked', $(this).next('.js-verse__text').text())
      console.log('verse', $(this).data('book_number'), $(this).data('chapter_number'), $(this).data('verse_number'))

class App.Verses
  constructor: ()->
    $('.js-verse').each ()->
      verse = new Verse($(this))
