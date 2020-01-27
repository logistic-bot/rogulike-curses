run: clean
	@ruby main.rb

clean:
	@touch log.log
	@rm log.log

debug:
	bat log.log
