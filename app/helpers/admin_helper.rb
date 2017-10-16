module AdminHelper
    def exportForm3921(form_fields)
    #only for Form 3921
    #1st 750 records - Transmitter “T” Record
            #set all form field to blank if the are not exist
            form_fields['transferors_fin'] ||= " "
            form_fields['transferors_name_address'] ||= " "
            if form_fields['transferors_name_address'].lines.first.blank?
                first_line = "_"
            else 
                first_line = form_fields['transferors_name_address'].lines.first
            end
            if form_fields['transferors_name_address'].lines.second.blank?
                second_line = "_"
            else 
                second_line = form_fields['transferors_name_address'].lines.second
            end
            if form_fields['transferors_name_address'].lines.third.blank?
                third_line = "_"
            else 
                third_line = form_fields['transferors_name_address'].lines.third
            end

            returned_data = 'T' #begining of the file -lenght 1
            returned_data += '2017' #lenght 4
            returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
            returned_data += form_fields['transferors_fin'] + (" "*(9-(form_fields['transferors_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
            returned_data += '93A66' + (" "*(5-('93A66'.to_s.length))) #5 characters - Transmitter Control Code
            returned_data += " "*7 #7 characters - blank
            returned_data += 'T' # T if it is a test file otherwise blank -lenght 1
            returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
            data = first_line.strip.truncate_words(2,omission: '')
            returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
            data2 = (first_line.slice! data).strip
            returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify.

            data = first_line.strip.truncate_words(2,omission: '')
            returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
            data2 = (first_line.slice! data).strip
            returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify. 
            data = second_line.strip              
            returned_data += data + (" "*(40-(data.to_s.length))) #40 characters Requered
            data = third_line.strip 
            data = " " if data.blank?
            data_array =  data.split(/\W+/)   
            data_zip = data_array[-1]
            data_zip = " " if data_zip.blank?
            data_zip = data_zip[0..8] if data_zip.length>9 
            data_state = data_array[-2]
            data_state = " " if data_state.blank?
            data_state = data_state[0..1] if data_state.length>2
            data_sliced = data.slice! data_zip
            data_city = data_sliced.slice! data_state  
            data_city = " " if data_city.blank?
            returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 characters Requered
            returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 characters Requered
            returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 characters Requered
            returned_data += " "*15 #15 blank characters 
            returned_data += '00000001' #8 characters Total Number of Payees 
            returned_data += 'Dejan Sabados                           ';#40 characters
            returned_data += '1111111111     ' #15 characters Requered
        #359-408       
            returned_data += 'dejansabados@yahoo.com                            ' #50 characters 
        #409-499
            returned_data += " "*91 #91 characters - blank
        #500-507
            returned_data += "00000001"; # number of the record T record is always first 8 characters
        #508-517
            returned_data += "I" #vendor indicator I if there are no vendor
            returned_data += " "*10 #blanks
            returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*2 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*9 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*15 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*35 #blanks
            returned_data += " "*1 #used only if Vendors Software is used otherwise blanks
            returned_data += " "*8 #blanks
            returned_data += " "*2 #blanks

    #2nd 750 records - Payer "A" Record
            returned_data += 'A' #begining of the record -lenght 1
            returned_data += '2017' #lenght 4
            returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
            returned_data += " "*5 #blanks
            returned_data += form_fields['transferors_fin'] + (" "*(9-(form_fields['transferors_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
            #first four characters of the payer last name
            returned_data += " "*4 #blanks of first four characters of the payers last name
            returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
            returned_data += "N " #type of return "N " for 3921
            returned_data += "34              " # 3 for Exercise price per share; 4 for Fair market value of share on exercise date, 16 chars lenght
            returned_data += " "*8 #blanks
            returned_data += " " #blank if payer is US citizen 
            data5 = first_line.strip.truncate_words(2,omission: '')
            returned_data += data5 + (" "*(40-(data5.to_s.length))) #40 characters - transmitter name. Left justify.
            returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
            returned_data += "0" #if there is no transfer agent
            data6 = second_line.strip              
            returned_data += data6 + (" "*(40-(data6.to_s.length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
            returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 payers city if there is not transfer agent
            returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 payers state if there is not transfer agent
            returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 payers zip if there is not transfer agent
            returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
            returned_data += " "*260 #blanks
            returned_data += "00000002" #the second record
            returned_data += " "*243 #blanks
    #3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
            returned_data += 'B' #begining of the record -lenght 1
            returned_data += '2017' #lenght 4
            returned_data += ' ' #is this correction or not ? enter 1 if it is otherwise blank field
            if (form_fields['employees_name'])
                returned_data += form_fields['employees_name'].split.last[0..3] #employees_name the first four characters of the last name
            else 
                returned_data += "    "
            end
            returned_data += "2" #Type of TIN 2 is for an individual 
            if (form_fields['employees_id'])
                data_tin = form_fields['employees_id'].delete("^a-zA-Z0-9") 
            else 
                data_tin = ''
            end
            returned_data += data_tin + (" "*(9-(data_tin.to_s.length))) #Payee’s Taxpayer Identification Number (TIN)
            data_account = form_fields['account_number']
            if (!data_account) 
               data_account = rand(99999999999999999999).to_s #generate 20 random number 
            end
            returned_data += data_account + (" "*(20-(data_account.to_s.length))) 
            returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
            returned_data += " "*10 #blanks
            returned_data += "0"*12 #Payment Amount 1*
            returned_data += "0"*12 #Payment Amount 2*
            if (form_fields['3'])
                data_amount3 = sprintf('%.2f', form_fields['3'])
                data_amount3 = data_amount3.tr('.', '')
                returned_data += ("0"*(12-(data_amount3.to_s.length)))+data_amount3
            else 
                returned_data += "0"*12 #Payment Amount 3*
            end
            if (form_fields['4'])
                data_amount4 = sprintf('%.2f', form_fields['4'])
                data_amount4 = data_amount4.tr('.', '')
                returned_data += ("0"*(12-(data_amount4.to_s.length)))+data_amount4
            else 
                returned_data += "0"*12 #Payment Amount 4*
            end
            returned_data += "0"*12 #Payment Amount 5*
            returned_data += "0"*12 #Payment Amount 6*
            returned_data += "0"*12 #Payment Amount 7*
            returned_data += "0"*12 #Payment Amount 8*
            returned_data += "0"*12 #Payment Amount 9*
            returned_data += "0"*12 #Payment Amount A*
            returned_data += "0"*12 #Payment Amount B*
            returned_data += "0"*12 #Payment Amount C*
            returned_data += "0"*12 #Payment Amount D*
            returned_data += "0"*12 #Payment Amount E*
            returned_data += "0"*12 #Payment Amount F*
            returned_data += "0"*12 #Payment Amount G*
            returned_data += " " #blank if US citizen otherwise enter 1
            if (form_fields['employees_name'])
                data_employees_name = form_fields['employees_name'].split.last(2).join(" ") 
            else
                data_employees_name = ''
            end
            returned_data +=  data_employees_name + (" "*(40-(data_employees_name.to_s.length))) #40 First payee name line -employees_name
            returned_data += " "*40 #40 Second payee name line
            returned_data += " "*40 #40 blanks
            if (form_fields['street_address']) 
                street_address = form_fields['street_address'].strip;
            else
                street_address = ' ';
            end
            returned_data +=  street_address + (" "*(40-(street_address.to_s.length))) #40 Payee mailing address
            returned_data += " "*40 #40 blanks
                    
            if (form_fields['city_town_state']) 
                city_town_state = form_fields['city_town_state'].strip;
            else
                city_town_state = ' ';
            end
            city_town_state = " " if city_town_state.blank?
            city_town_state_array =  city_town_state.split(/\W+/)   
            zip = city_town_state_array[-1]
            zip = " " if zip.blank?
            zip = zip[0..8] if zip.length>9 
            state = city_town_state_array[-2]
            state = " " if state.blank?
            state = state[0..1] if state.length>2
            city_town_state_sliced = city_town_state.slice! zip
            city = city_town_state_sliced.slice! state  
            city = " " if city.blank?  
           
            returned_data +=  city + (" "*(40-(city.to_s.length))) #40 payee city , town or postal office (do not enter zip)
            returned_data +=  state + (" "*(2-(state.to_s.length)))#2 valid U.S Postal Service state
            returned_data +=  zip + (" "*(9-(zip.to_s.length)))#9 Payee ZIP code
            returned_data += " " # blank
            returned_data += "00000003" #8 Record Sequence Number
            returned_data += " "*36 #36 blanks
    #these records are specifed for form 3921 
            returned_data += " "*3 #3 blanks
            if (form_fields['1']) 
                date_granted = form_fields['1'];
            else
                date_granted = ' ';
            end
            returned_data +=  date_granted + (" "*(8-(date_granted.to_s.length))) #8 date option granted
            if (form_fields['2']) 
                date_exercised = form_fields['2'];
            else
                date_exercised = ' ';
            end
            returned_data +=  date_exercised + (" "*(8-(date_exercised.to_s.length))) #8 date option exercised
            if (form_fields['5']) 
                number_of_shares = form_fields['5'];
            else
                number_of_shares = '0';
            end
                    returned_data += ("0"*(8-(number_of_shares.to_s.length))) + number_of_shares.to_s #8 number of shares transferred
            returned_data += " "*4 #4 blanks
            if (form_fields['6']) 
                other_than_transferor = form_fields['6'];
            else
                other_than_transferor = ' ';
            end
            returned_data +=  other_than_transferor + (" "*(40-(other_than_transferor.to_s.length))) #40 if other than transferor information
            returned_data += " "*48 #48 blank
            returned_data += " "*60 #60 special data entries or blanks 
            returned_data += " "*26 #26 blanks
            returned_data += " "*2 #2 blanks
    # Payer C record (control record)
            returned_data += 'C' # enter C
            returned_data += '00000001' #8 total number of payees
            returned_data += ' '*6 #6 blanks

            returned_data += "0"*18 #Payment Amount 1*
            returned_data += "0"*18 #Payment Amount 2*
            if (data_amount3)
                returned_data += data_amount3 + (" "*(18-(data_amount3.to_s.length))) 
            else 
                returned_data += "0"*18 #Payment Amount 3*
            end
            if (data_amount4)
                returned_data += data_amount4 + (" "*(18-(data_amount4.to_s.length))) 
            else 
                returned_data += "0"*18 #Payment Amount 4*
            end
            returned_data += "0"*18 #Payment Amount 5*
            returned_data += "0"*18 #Payment Amount 6*
            returned_data += "0"*18 #Payment Amount 7*
            returned_data += "0"*18 #Payment Amount 8*
            returned_data += "0"*18 #Payment Amount 9*
            returned_data += "0"*18 #Payment Amount A*
            returned_data += "0"*18 #Payment Amount B*
            returned_data += "0"*18 #Payment Amount C*
            returned_data += "0"*18 #Payment Amount D*
            returned_data += "0"*18 #Payment Amount E*
            returned_data += "0"*18 #Payment Amount F*
            returned_data += "0"*18 #Payment Amount G* 

            returned_data += ' '*196 #196 blanks
            returned_data += "00000004" #8 Record Sequence Number
            returned_data += ' '*241 #241 blanks
            returned_data += ' '*2 #2 blanks
    # K record used only when state reporting approval has been granted
    # F record
            returned_data += 'F' #enter F
            returned_data += '00000001' #8 number of A records
            returned_data += '0'*21 #21 zeros
            returned_data += ' '*19 #19 blanks
            returned_data += '00000001' #8 number of A records
            returned_data += ' '*442 #442 blanks
            returned_data += "00000005" #8 Record Sequence Number
            returned_data += ' '*241 #241 blanks
            returned_data += ' '*2 #2 blanks
    #end of file

            return returned_data
    end











    def exportForm1099a(form_fields)
    #only for Form 1099a
    #1st 750 records - Transmitter “T” Record
        #set all form field to blank if the are not exist
        form_fields['lenders_fin'] ||= " "       

        form_fields['lenders_name_address'] ||= " "
        if form_fields['lenders_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['lenders_name_address'].lines.first
        end
        if form_fields['lenders_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['lenders_name_address'].lines.second
        end
        if form_fields['lenders_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['lenders_name_address'].lines.third
        end
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
        returned_data += form_fields['lenders_fin'] + (" "*(9-(form_fields['lenders_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
        
        returned_data += '93A66' + (" "*(5-('93A66'.to_s.length))) #5 characters - Transmitter Control Code
        returned_data += " "*7 #7 characters - blank
        returned_data += 'T' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
        data2 = (first_line.slice! data).strip
        returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify.

        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
        data2 = (first_line.slice! data).strip
        returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify. 
        data = second_line.strip              
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters Requered
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0..8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0..1] if data_state.length>2
        data_sliced = data.slice! data_zip
        data_city = data_sliced.slice! data_state  
        data_city = " " if data_city.blank?
        returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 characters Requered
        returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 characters Requered
        returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 characters Requered
        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'Dejan Sabados                           ';#40 characters
        returned_data += '1111111111     ' #15 characters Requered
    #359-408       
        returned_data += 'dejansabados@yahoo.com                            ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += "I" #vendor indicator I if there are no vendor
        returned_data += " "*10 #blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*2 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*9 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*15 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*35 #blanks
        returned_data += " "*1 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*8 #blanks
        returned_data += " "*2 #blanks

#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['lenders_fin'] + (" "*(9-(form_fields['lenders_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "4 " #type of return "4 " " for 1099-A
        returned_data += "24              " # 3 for Exercise price per share; 4 for Fair market value of share on exercise date, 16 chars lenght
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s.length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s.length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 payers city if there is not transfer agent
        returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 payers state if there is not transfer agent
        returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*243 #blanks
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['employees_name'])
            returned_data += form_fields['employees_name'].split.last[0..3] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['borrowers_id'])
            data_tin = form_fields['borrowers_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin + (" "*(9-(data_tin.to_s.length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account + (" "*(20-(data_account.to_s.length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        returned_data += "0"*12 #Payment Amount 1*
        returned_data += "0"*12 #Payment Amount 2*
        if (form_fields['2'])
            data_amount3 = sprintf('%.2f', form_fields['2'])
            data_amount3 = data_amount3.tr('.', '')
            returned_data += ("0"*(12-(data_amount3.to_s.length)))+data_amount3
        else 
            returned_data += "0"*12 #Payment Amount 3*
        end
        if (form_fields['4'])
            data_amount4 = sprintf('%.2f', form_fields['4'])
            data_amount4 = data_amount4.tr('.', '')
            returned_data += ("0"*(12-(data_amount4.to_s.length)))+data_amount4
        else 
            returned_data += "0"*12 #Payment Amount 4*
        end
        returned_data += "0"*12 #Payment Amount 5*
        returned_data += "0"*12 #Payment Amount 6*
        returned_data += "0"*12 #Payment Amount 7*
        returned_data += "0"*12 #Payment Amount 8*
        returned_data += "0"*12 #Payment Amount 9*
        returned_data += "0"*12 #Payment Amount A*
        returned_data += "0"*12 #Payment Amount B*
        returned_data += "0"*12 #Payment Amount C*
        returned_data += "0"*12 #Payment Amount D*
        returned_data += "0"*12 #Payment Amount E*
        returned_data += "0"*12 #Payment Amount F*
        returned_data += "0"*12 #Payment Amount G*
        returned_data += " " #blank if US citizen otherwise enter 1

        if (form_fields['borrowers_name'])
            data_employees_name = form_fields['borrowers_name'].split.last(2).join(" ") 
        else
            data_employees_name = ''
        end
        returned_data +=  data_employees_name + (" "*(40-(data_employees_name.to_s.length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s.length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town']) 
            city_town_state = form_fields['city_town'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0..8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0..1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s.length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state + (" "*(2-(state.to_s.length)))#2 valid U.S Postal Service state
        returned_data +=  zip + (" "*(9-(zip.to_s.length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099a 
        returned_data += " "*3 #3 blanks
        if (form_fields['5']='checked') 
            personal_liability = form_fields['1'];
        else
            personal_liability = ' ';
        end
        returned_data +=  personal_liability #1 personal liability indicator

        if (form_fields['1']) 
            acquisition_date = form_fields['1'];
        else
            acquisition = ' ';
        end
        returned_data +=  acquisition + (" "*(8-(acquisition.to_s.length))) #8 Date of Lender’s Acquisition or Knowledge of Abandonment
        if (form_fields['6']) 
            description_of_property = form_fields['6'].strip;
        else
            description_of_property = ' ';
        end
        returned_data += description_of_property.to_s + (" "*(39-(description_of_property.to_s.length))) #39
        returned_data += " "*68 #68 blanks
        returned_data += " "*60 #60 special data entries or blanks 
        returned_data += " "*26 #26 blanks
        returned_data += " "*2 #2 blanks
# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        returned_data += "0"*18 #Payment Amount 1*
        returned_data += "0"*18 #Payment Amount 2*
        if (data_amount2)
            returned_data += data_amount2 + (" "*(18-(data_amount2.to_s.length))) 
        else 
            returned_data += "0"*18 #Payment Amount 3*
        end
        if (data_amount4)
            returned_data += data_amount4 + (" "*(18-(data_amount4.to_s.length))) 
        else 
            returned_data += "0"*18 #Payment Amount 4*
        end
        returned_data += "0"*18 #Payment Amount 5*
        returned_data += "0"*18 #Payment Amount 6*
        returned_data += "0"*18 #Payment Amount 7*
        returned_data += "0"*18 #Payment Amount 8*
        returned_data += "0"*18 #Payment Amount 9*
        returned_data += "0"*18 #Payment Amount A*
        returned_data += "0"*18 #Payment Amount B*
        returned_data += "0"*18 #Payment Amount C*
        returned_data += "0"*18 #Payment Amount D*
        returned_data += "0"*18 #Payment Amount E*
        returned_data += "0"*18 #Payment Amount F*
        returned_data += "0"*18 #Payment Amount G* 

        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += ' '*2 #2 blanks
# K record used only when state reporting approval has been granted
# F record
        returned_data += 'F' #enter F
        returned_data += '00000001' #8 number of A records
        returned_data += '0'*21 #21 zeros
        returned_data += ' '*19 #19 blanks
        returned_data += '00000001' #8 number of A records
        returned_data += ' '*442 #442 blanks
        returned_data += "00000005" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += ' '*2 #2 blanks
#end of file
        return returned_data
    end







    def exportForm1099b(form_fields)
    #only for Form 1099b
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        form_fields['payers_fin'] ||= " "       

        form_fields['payers_name_address'] ||= " "
        if form_fields['payers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers_name_address'].lines.first
        end
        if form_fields['payers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['payers_name_address'].lines.second
        end
        if form_fields['payers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['payers_name_address'].lines.third
        end
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
        returned_data += form_fields['payers_fin'] + (" "*(9-(form_fields['payers_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
        
        returned_data += '93A66' + (" "*(5-('93A66'.to_s.length))) #5 characters - Transmitter Control Code
        returned_data += " "*7 #7 characters - blank
        returned_data += 'T' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
        data2 = (first_line.slice! data).strip
        returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify.

        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters - transmitter name. Left justify.
        data2 = (first_line.slice! data).strip
        returned_data += data2 + (" "*(40-(data2.to_s.length))) #40 characters - transmitter aditional data. Left justify. 
        data = second_line.strip              
        returned_data += data + (" "*(40-(data.to_s.length))) #40 characters Requered
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0..8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0..1] if data_state.length>2
        data_sliced = data.slice! data_zip
        data_city = data_sliced.slice! data_state  
        data_city = " " if data_city.blank?
        returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 characters Requered
        returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 characters Requered
        returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 characters Requered
        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'Dejan Sabados                           ';#40 characters
        returned_data += '1111111111     ' #15 characters Requered
    #359-408       
        returned_data += 'dejansabados@yahoo.com                            ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += "I" #vendor indicator I if there are no vendor
        returned_data += " "*10 #blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*2 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*9 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*40 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*15 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*35 #blanks
        returned_data += " "*1 #used only if Vendors Software is used otherwise blanks
        returned_data += " "*8 #blanks
        returned_data += " "*2 #blanks
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['payers_fin'] + (" "*(9-(form_fields['payers_fin'].to_s.length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "B " #type of return "4 " " for 1099-B

        returned_data += "234579ABCD      " #16 paument codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s.length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s.length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 payers city if there is not transfer agent
        returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 payers state if there is not transfer agent
        returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*243 #blanks

#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name'])
            returned_data += form_fields['recipients_name'].split.last[0..3] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin + (" "*(9-(data_tin.to_s.length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_num']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account + (" "*(20-(data_account.to_s.length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 234579ABCD 
        returned_data += "0"*12 #Payment Amount 1*
        if (form_fields['1d'])
            data_amount = sprintf('%.2f', form_fields['1d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 2, Proceeds (For forward contracts)
        end
        if (form_fields['1e'])
            data_amount = sprintf('%.2f', form_fields['1e'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 3 Cost or other basis
        end
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 4 Federal income tax withheld (backup withholding). Do not report negative amounts.
        end
        if (form_fields['1g'])
            data_amount = sprintf('%.2f', form_fields['1g'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 5 Wash Sale Loss Disallowed
        end
        returned_data += "0"*12 #Payment Amount 6*
        if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 7 Bartering
        end
        returned_data += "0"*12 #Payment Amount 8* 
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount 9 Profit (or loss) realized in 2017 
        end
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount A Unrealized profit (or loss) on open contracts 12/31/2016 
        end
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount B Unrealized profit (or loss) on open contracts 12/31/2017
        end
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount C Aggregate profit (or loss)
        end
        if (form_fields['1f'])
            data_amount = sprintf('%.2f', form_fields['1f'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s.length)))+data_amount
        else 
            returned_data += "0"*12 #Payment Amount D Accrued Market Discount
        end
        returned_data += "0"*12 #Payment Amount E*
        returned_data += "0"*12 #Payment Amount F*
        returned_data += "0"*12 #Payment Amount G*
        returned_data += " " #blank if US citizen otherwise enter 1
# - ovde sam stao stranica 74
        if (form_fields['borrowers_name'])
            data_employees_name = form_fields['borrowers_name'].split.last(2).join(" ") 
        else
            data_employees_name = ''
        end
        returned_data +=  data_employees_name + (" "*(40-(data_employees_name.to_s.length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s.length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town']) 
            city_town_state = form_fields['city_town'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0..8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0..1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s.length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state + (" "*(2-(state.to_s.length)))#2 valid U.S Postal Service state
        returned_data +=  zip + (" "*(9-(zip.to_s.length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099a 
        returned_data += " "*3 #3 blanks
        if (form_fields['5']='checked') 
            personal_liability = form_fields['1'];
        else
            personal_liability = ' ';
        end
        returned_data +=  personal_liability #1 personal liability indicator

        if (form_fields['1']) 
            acquisition_date = form_fields['1'];
        else
            acquisition = ' ';
        end
        returned_data +=  acquisition + (" "*(8-(acquisition.to_s.length))) #8 Date of Lender’s Acquisition or Knowledge of Abandonment
        if (form_fields['6']) 
            description_of_property = form_fields['6'].strip;
        else
            description_of_property = ' ';
        end
        returned_data += description_of_property.to_s + (" "*(39-(description_of_property.to_s.length))) #39
        returned_data += " "*68 #68 blanks
        returned_data += " "*60 #60 special data entries or blanks 
        returned_data += " "*26 #26 blanks
        returned_data += " "*2 #2 blanks
# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        returned_data += "0"*18 #Payment Amount 1*
        returned_data += "0"*18 #Payment Amount 2*
        if (data_amount2)
            returned_data += data_amount2 + (" "*(18-(data_amount2.to_s.length))) 
        else 
            returned_data += "0"*18 #Payment Amount 3*
        end
        if (data_amount4)
            returned_data += data_amount4 + (" "*(18-(data_amount4.to_s.length))) 
        else 
            returned_data += "0"*18 #Payment Amount 4*
        end
        returned_data += "0"*18 #Payment Amount 5*
        returned_data += "0"*18 #Payment Amount 6*
        returned_data += "0"*18 #Payment Amount 7*
        returned_data += "0"*18 #Payment Amount 8*
        returned_data += "0"*18 #Payment Amount 9*
        returned_data += "0"*18 #Payment Amount A*
        returned_data += "0"*18 #Payment Amount B*
        returned_data += "0"*18 #Payment Amount C*
        returned_data += "0"*18 #Payment Amount D*
        returned_data += "0"*18 #Payment Amount E*
        returned_data += "0"*18 #Payment Amount F*
        returned_data += "0"*18 #Payment Amount G* 

        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += ' '*2 #2 blanks
# K record used only when state reporting approval has been granted
# F record
        returned_data += 'F' #enter F
        returned_data += '00000001' #8 number of A records
        returned_data += '0'*21 #21 zeros
        returned_data += ' '*19 #19 blanks
        returned_data += '00000001' #8 number of A records
        returned_data += ' '*442 #442 blanks
        returned_data += "00000005" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += ' '*2 #2 blanks
#end of file
        return returned_data
    end
end
