# TODO: Refactor this model to use an internal Game Model instead
# of containing the game logic directly.
class window.App extends Backbone.Model
  initialize: ->
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()

    #Player Interactions
    @get('playerHand').on('hit', ->
        if @trueScore() > 21
          console.log(@minScore(), @trueScore())
          $('.hit-button').prop('disabled', true)
          $('.stand-button').prop('disabled', true)
          @stand()
      )

    #Dealer Behavior
    @get('playerHand').on('stand', =>
      $('.hit-button').prop('disabled', true)
      $('.stand-button').prop('disabled', true)
      dealer = @get('dealerHand')
      dealer.at(0).flip()
      if @get('playerHand').trueScore() <= 21
        dealer.hit() while dealer.trueScore() < 16
      dealer.stand()
      )

    #Endgame Stuff
    @get('dealerHand').on('stand', =>
      playerScore = @get('playerHand').trueScore()
      dealerScore = @get('dealerHand').trueScore()

      if playerScore <= 21
        if playerScore == dealerScore and playerScore != 21
          $('.game-result').html("Tie!")
        else if playerScore > dealerScore or playerScore == 21 or dealerScore > 21
          $('.game-result').html("Player Wins!")
        else
          $('.game-result').html("Dealer Wins!")
      else
        $('.game-result').html("Dealer Wins!")
      )

