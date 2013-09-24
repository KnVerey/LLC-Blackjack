def sum_cards(card_array)
	sum = 0;
	card_array.each do |card|
		if card > 11
			sum = sum + 10
		else
			sum = sum + card
		end
	end

	if sum>21 && card_array.include?(11)
		card_array.each do |card|
			if sum>21 && card==11
				sum = sum-10
			end
		end
	end

	return sum
end

def print_cards (hand)
	hand.each do |card|
		if card == 11
			print " -A- "
		elsif card==12
			print " -J- "
		elsif card==13
			print " -Q- "
		elsif card==14
			print " -K- "
		else				
			print " -#{card}- "
		end
	end
	puts ""
end

def deal_card()
	card = 2+rand(13)
end

def get_bet(balance)
	bet=0	
	until bet<=balance && bet>0
		begin
			bet=gets.chomp
			return bet if bet=="exit"

			bet=Float(bet)
		rescue ArgumentError
			print "That's not a number! How much do you want to bet (dollars, no cents)?  "
			retry
		end
		if bet>balance
			print "Sorry, no credit here. Enter a bet within your balance of #{balance}:  "
		elsif bet==0
			print "You can't play if you don't bet! How much will it be?  "
		else
			if bet%1==0.0
				bet = bet.to_i 
			else
				bet = bet.floor if bet%1<0.5
				bet = bet.ceil if bet%1>=0.5
				bet = 1 if bet<1
				puts "Your bet will be rounded to a whole dollar amount: $#{bet}"
			end
		end	
	end
	return bet
end

puts "\n\n---------------------\nWelcome to Blackjack!\n---------------------\n"
bet = "none"
balance = 100
print "\nYou've got $#{balance} to play with. \nHow much do you want to bet?  "
bet = get_bet(balance)

while bet!="exit" && balance>0
	dealer = [deal_card(), deal_card()]
	player = [deal_card(), deal_card()]

	print "\nYour starting hand is:"
	print_cards(player)
	print "Your starting total is #{sum_cards(player)}. "

	while sum_cards(player)<21
		puts "\nType 'h' to hit or 's' to stand."
		move=gets.chomp

		if move=="h"
			player << deal_card()
			print "\nYour new hand is:"
			print_cards(player)
			print "Your new total is #{sum_cards(player)}. "
		elsif move=="s"
			break
		else
			print "What was that again? "	
		end
	end

	if sum_cards(player)==21
		sleep 1
		puts "\n\n*** Congrats! YOU WIN!!! ***\n\n"
		balance = balance + bet
	elsif sum_cards(player) >21
		sleep 1
		print "\n\nAwww, you lost. "
		balance = balance - bet
	else
		print "\nThe dealer's starting hand is:"
		print_cards(dealer)
		puts "The dealer started with a total of #{sum_cards(dealer)}.\n"
		sleep 3

		while sum_cards(dealer)<17
			puts "\nThe dealer takes a hit.\n"
			sleep 1
			dealer << deal_card()
			print "The dealer's new hand is:"
			print_cards(dealer)
			sleep 3
			puts "The dealer's new total is #{sum_cards(dealer)}.\n"
			sleep 3
		end

		if sum_cards(dealer)<21
			puts "The dealer stands."
			sleep 1
		end

		if sum_cards(dealer)>21 || sum_cards(player)>sum_cards(dealer)
			puts "\n*** Congrats! YOU WIN!!! ***\n"
			balance = balance + bet
		elsif sum_cards(player)==sum_cards(dealer)
			puts "\n*** It's a tie! ***\n"	
		else
			print "\nAww, you lost. "
			balance = balance - bet
		end
	end

	if balance<=0
		puts "You've run out of money! Better luck next time. Goodbye!"
		play="exit"
	else
		puts "Why not play another round! Your balance is $#{balance}."
		print "Enter a bet to play again or type 'exit' to quit: "
		bet = get_bet(balance)
	end
end
