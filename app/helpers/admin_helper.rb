module AdminHelper
    def exportForm3921(form_fields)
    #@ info that name, address, city state zip should be separated in rows s
    #@ all commas should be removed from name , title , address etc..
    #@questions : is payer TIN same as payer ID
    #@convert dates to date fields
    #only for Form 3921
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

    #1st 750 records - Transmitter “T” Record
            returned_data = 'T' #begining of the file -lenght 1
            returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
            returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
            returned_data += '473852932' #9 characters - Transmitter'S federal identification number
            #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
            returned_data += '93A66'
            returned_data += " "*7 #7 characters - blank
            returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
            returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
            data = first_line.strip.truncate_words(2,omission: '')
            #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
            returned_data += 'CODE ACCOUNTING'+ ' '*25
            data2 = first_line
            data2.slice! data
            data2 = data2.strip
            # returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
            returned_data += ' '*40
            if form_fields['transferors_name_address'].lines.first.blank?
                first_line = "_"
            else 
                first_line = form_fields['transferors_name_address'].lines.first
            end
            data = first_line.strip.truncate_words(2,omission: '')
            #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
            returned_data += 'CODE ACCOUNTING'+ ' '*25
            data2 = first_line
            data2.slice! data
            data2 = data2.strip
            #returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
            returned_data += ' '*40
            data = second_line.strip              
            #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
            returned_data += '249 W. JACKSON STREET STE 260'+' '*11
            third_line.delete! ',/-'
            data = third_line.strip 
            data = " " if data.blank?
            data_array =  data.split(/\W+/)   
            data_zip = data_array[-1]
            data_zip = " " if data_zip.blank?
            data_zip = data_zip[0...8] if data_zip.length>9 
            data_state = data_array[-2]
            data_state = " " if data_state.blank?
            data_state = data_state[0...1] if data_state.length>2
            data.slice! data_zip
            data.slice! data_state  
            data_city = data
            data_city = " " if data_city.blank?
            #returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
            #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
            #@ need a validation here should be 9 digits :
            #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
            returned_data += 'Hayward'+' '*33
            returned_data += 'CA'
            returned_data += '94544'+' '*4

            returned_data += " "*15 #15 blank characters 
            returned_data += '00000001' #8 characters Total Number of Payees 
            returned_data += 'SEAN ALLABAND                           ';#40 characters
            returned_data += '5107062877     ' #15 characters Requered
        #359-408       
            returned_data += 'sean@codeaccounting.com                           ' #50 characters 
        #409-499
            returned_data += " "*91 #91 characters - blank
        #500-507
            returned_data += "00000001"; # number of the record T record is always first 8 characters
        #508-517
            returned_data += " "*10 #blanks
            returned_data += "I" #vendor indicator I if there are no vendor
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
            returned_data += "\r\n" 
    #2nd 750 records - Payer "A" Record
            returned_data += 'A' #begining of the record -lenght 1
            returned_data += '2017' #lenght 4
            returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
            returned_data += " "*5 #blanks
            returned_data += form_fields['transferors_fin'].to_s[0...9] + (" "*(9-(form_fields['transferors_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
            #first four characters of the payer last name
            returned_data += " "*4 #blanks of first four characters of the payers last name
            returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
            returned_data += "N " #type of return "N " for 3921
            returned_data += "34              " # 3 for Exercise price per share; 4 for Fair market value of share on exercise date, 16 chars lenght
            returned_data += " "*8 #blanks
            returned_data += " " #blank if payer is US citizen 
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
            data5 = first_line.strip.truncate_words(2,omission: '')
            returned_data += data5.to_s[0...40] + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
            returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
            returned_data += "0" #if there is no transfer agent
            data6 = second_line.strip              
            returned_data += data6.to_s[0...40] + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
            returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
            returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
            returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
            returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
            returned_data += " "*260 #blanks
            returned_data += "00000002" #the second record
            returned_data += " "*241 #blanks
            returned_data += "\r\n" 
    #3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
            returned_data += 'B' #begining of the record -lenght 1
            returned_data += '2017' #lenght 4
            returned_data += ' ' #is this correction or not ? enter 1 if it is otherwise blank field
            if (form_fields['employees_name'])
                returned_data += form_fields['employees_name'].split.last[0...4] #employees_name the first four characters of the last name
            else 
                returned_data += "    "
            end
            returned_data += "2" #Type of TIN 2 is for an individual 
            if (form_fields['employees_id'])
                data_tin = form_fields['employees_id'].delete("^a-zA-Z0-9") 
            else 
                data_tin = ''
            end
            returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
            data_account = form_fields['account_number']
            if (!data_account) 
               data_account = rand(99999999999999999999).to_s #generate 20 random number 
            end
            returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
            returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
            returned_data += " "*10 #blanks
            returned_data += "0"*12 #Payment Amount 1*
            returned_data += "0"*12 #Payment Amount 2*
            if (form_fields['3'])
                data_amount3 = sprintf('%.2f', form_fields['3'])
                data_amount3 = data_amount3.tr('.', '')
                returned_data += ("0"*(12-(data_amount3.to_s[0...12].length)))+data_amount3.to_s[0...12]
            else 
                returned_data += "0"*12 #Payment Amount 3*
            end
            if (form_fields['4'])
                data_amount4 = sprintf('%.2f', form_fields['4'])
                data_amount4 = data_amount4.tr('.', '')
                returned_data += ("0"*(12-(data_amount4.to_s[0...12].length)))+data_amount4.to_s[0...12]
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
            returned_data +=  data_employees_name.to_s[0...40] + (" "*(40-(data_employees_name.to_s[0...40].length))) #40 First payee name line -employees_name
            returned_data += " "*40 #40 Second payee name line
            returned_data += " "*40 #40 blanks
            if (form_fields['street_address']) 
                street_address = form_fields['street_address'].strip;
            else
                street_address = ' ';
            end
            returned_data +=  street_address.to_s[0...40] + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
            zip = zip[0...8] if zip.length>9 
            state = city_town_state_array[-2]
            state = " " if state.blank?
            state = state[0...1] if state.length>2
            city_town_state_sliced = city_town_state.slice! zip
            city = city_town_state_sliced.slice! state  
            city = " " if city.blank?  
           
            returned_data +=  city.to_s[0...40] + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
            returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
            returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
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
            returned_data +=  date_granted.to_s[0...8] + (" "*(8-(date_granted.to_s[0...8].length))) #8 date option granted
            if (form_fields['2']) 
                date_exercised = form_fields['2'];
            else
                date_exercised = ' ';
            end
            returned_data +=  date_exercised.to_s[0...8] + (" "*(8-(date_exercised.to_s[0...8].length))) #8 date option exercised
            if (form_fields['5']) 
                number_of_shares = form_fields['5'];
            else
                number_of_shares = '0';
            end
                    returned_data += ("0"*(8-(number_of_shares.to_s[0...8].length))) + number_of_shares.to_s[0...8] #8 number of shares transferred
            returned_data += " "*4 #4 blanks
            if (form_fields['6']) 
                other_than_transferor = form_fields['6'];
            else
                other_than_transferor = ' ';
            end
            returned_data +=  other_than_transferor.to_s[0...40] + (" "*(40-(other_than_transferor.to_s[0...40].length))) #40 if other than transferor information
            returned_data += " "*48 #48 blank
            returned_data += " "*60 #60 special data entries or blanks 
            returned_data += " "*26 #26 blanks
            returned_data += "\r\n" 
    # Payer C record (control record)
            returned_data += 'C' # enter C
            returned_data += '00000001' #8 total number of payees
            returned_data += ' '*6 #6 blanks

            returned_data += "0"*18 #Payment Amount 1*
            returned_data += "0"*18 #Payment Amount 2*
            if (data_amount3)
                returned_data += ("0"*(18-(data_amount3.to_s[0...18].length))) + data_amount3.to_s[0...18]   
            else 
                returned_data += "0"*18 #Payment Amount 3*
            end
            if (data_amount4)
                returned_data += ("0"*(18-(data_amount4.to_s[0...18].length))) + data_amount4.to_s[0...18]
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
            returned_data += "\r\n" 
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
            returned_data += "\r\n" 
    #end of file

            return returned_data
    end











    def exportForm1099a(form_fields)
    #only for Form 1099a
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
    #1st 750 records - Transmitter “T” Record
        #set all form field to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['lenders_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['lenders_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 

#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['lenders_fin'].to_s[0...9] + (" "*(9-(form_fields['lenders_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "4 " #type of return "4 " " for 1099-A
        returned_data += "24              " # 3 for Exercise price per share; 4 for Fair market value of share on exercise date, 16 chars lenght
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
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
         #end of reset
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5.to_s[0...40] + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6.to_s[0...40] + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['employees_name'])
            returned_data += form_fields['employees_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['borrowers_id'])
            data_tin = form_fields['borrowers_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
      #TODO see how is this solved in Form bellow and make like that (to accept values with dollar sign etc )
        returned_data += "0"*12 #Payment Amount 1*
        returned_data += "0"*12 #Payment Amount 2*
        if (form_fields['2'])
            data_amount3 = sprintf('%.2f', form_fields['2'])
            data_amount3 = data_amount3.tr('.', '')
            returned_data += ("0"*(12-(data_amount3.to_s[0...12].length)))+data_amount3.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 3*
        end
        if (form_fields['4'])
            data_amount4 = sprintf('%.2f', form_fields['4'])
            data_amount4 = data_amount4.tr('.', '')
            returned_data += ("0"*(12-(data_amount4.to_s[0...12].length)))+data_amount4.to_s[0...12]
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
        returned_data +=  data_employees_name.to_s[0...40] + (" "*(40-(data_employees_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address.to_s[0...40] + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city.to_s[0...40] + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099a 
        returned_data += " "*3 #3 blanks
        if (form_fields['5']=='checked') 
            personal_liability = '1';
        else
            personal_liability = ' ';
        end
        returned_data +=  personal_liability #1 personal liability indicator

        if (form_fields['1']) 
            acquisition_date = form_fields['1'];
        else
            acquisition = ' ';
        end
        returned_data +=  acquisition.to_s[0...8] + (" "*(8-(acquisition.to_s[0...8].length))) #8 Date of Lender’s Acquisition or Knowledge of Abandonment
        if (form_fields['6']) 
            description_of_property = form_fields['6'].strip;
        else
            description_of_property = ' ';
        end
        returned_data += description_of_property.to_s[0...39] + (" "*(39-(description_of_property.to_s[0...39].length))) #39
        returned_data += " "*68 #68 blanks
        returned_data += " "*60 #60 special data entries or blanks 
        returned_data += " "*26 #26 blanks
        returned_data += "\r\n"
# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #TODO see how is this solved in Form bellow and make like that (to accept values with dollar sign etc )
        returned_data += "0"*18 #Payment Amount 1*
        returned_data += "0"*18 #Payment Amount 2*
        if (form_fields['2'])
            data_amount3 = sprintf('%.2f', form_fields['2'])
            data_amount3 = data_amount3.tr('.', '')
            returned_data += ("0"*(18-(data_amount3.to_s[0...18].length)))+data_amount3.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 3*
        end

        if (form_fields['4'])
            data_amount4 = sprintf('%.2f', form_fields['4'])
            data_amount4 = data_amount4.tr('.', '')
            returned_data += ("0"*(18-(data_amount4.to_s[0...18].length)))+data_amount4.to_s[0...18]
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
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end







    def exportForm1099b(form_fields)
    #only for Form 1099b
        form_fields['filers_fid'] ||= " "       

        form_fields['filers_name_address'] ||= " "
        if form_fields['filers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_address'].lines.first
        end
        if form_fields['filers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['filers_name_address'].lines.second
        end
        if form_fields['filers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['filers_name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1
        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['payers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2.to_s[0...40] + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'SEAN ALLABAND                           ';#40 characters

        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['payers_fin'].to_s[0...9] + (" "*(9-(form_fields['payers_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "B " #type of return "4 " " for 1099-B

        returned_data += "234579ABCD      " #16 paument codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen
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
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5.to_s[0...40] + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6.to_s[0...40] + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city.to_s[0...40] + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"

#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name'])
            returned_data += form_fields['recipients_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_num']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 234579ABCD 
        returned_data += "0"*12 #Payment Amount 1*
        if (form_fields['1d'])
            data_amount = sprintf('%.2f', form_fields['1d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 2, Proceeds (For forward contracts)
        end
        if (form_fields['1e'])
            data_amount = sprintf('%.2f', form_fields['1e'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 3 Cost or other basis
        end
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 4 Federal income tax withheld (backup withholding). Do not report negative amounts.
        end
        if (form_fields['1g'])
            data_amount = sprintf('%.2f', form_fields['1g'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 5 Wash Sale Loss Disallowed
        end
        returned_data += "0"*12 #Payment Amount 6*
        if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 7 Bartering
        end
        returned_data += "0"*12 #Payment Amount 8* 
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 9 Profit (or loss) realized in 2017 
        end
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount A Unrealized profit (or loss) on open contracts 12/31/2016 
        end
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount B Unrealized profit (or loss) on open contracts 12/31/2017
        end
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount C Aggregate profit (or loss)
        end
        if (form_fields['1f'])
            data_amount = sprintf('%.2f', form_fields['1f'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount D Accrued Market Discount
        end
        returned_data += "0"*12 #Payment Amount E*
        returned_data += "0"*12 #Payment Amount F*
        returned_data += "0"*12 #Payment Amount G*
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['recipients_name'])
            data_payee_name = form_fields['recipients_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name.to_s[0...40] + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address.to_s[0...40] + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city.to_s[0...40] + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099b 
        if (form_fields['2nd_tin_not']=='checked') 
            data = '2';
        else
            data = ' ';
        end
        returned_data +=  data #1 second TIN Notice (Optional)  '2nd_tin_not'
        data = " "
        if (form_fields['3']=='checked' && form_fields['5']=='unchecked') 
            data = '2';
        end
        if (form_fields['3']=='unchecked' && form_fields['5']=='checked') 
            data = '1';
        end
        returned_data +=  data #1 noncovered security indicator
        data = " "
        if (form_fields['2_short_term']=='checked' && form_fields['2_ordinary']=='unchecked') 
            data = '1';
        end
        if (form_fields['2_short_term']=='checked' && form_fields['2_ordinary']=='checked') 
            data = '3';
        end
        if (form_fields['2_long_term']=='checked' && form_fields['2_ordinary']=='unchecked') 
            data = '2';
        end
        if (form_fields['2_long_term']=='checked' && form_fields['2_ordinary']=='checked') 
            data = '4';
        end
        returned_data +=  data #1 type of Gain or Loss Indicator '2_short_term, 2_long_term, 2_ordinary'

        data =' '
        if (form_fields['6_gross']=='checked' && form_fields['6_net']=='unchecked') 
            data = '1';
        end
        if (form_fields['6_gross']=='unchecked' && form_fields['6_net']=='checked') 
            data = '2';
        end
        returned_data +=  data #1 Gross Preceeds Indicator  '6_gross' ('6_net')
        if (form_fields['1c']) 
            data = form_fields['1c'];
        else 
            data = ' '*8;
        end
        returned_data += (" "*(8-(data.to_s[0...8].length)))+data.to_s[0...8] #8 Date Sold or Disposed '1c' TODO: MAKI it DATE FIELD f THERE IS no DATE ENTER BLANK !
        if (form_fields['cusip_num']) 
            data = form_fields['cusip_num'];
        else 
            data = ' '*13;
        end
        returned_data += (" "*(13-(data.to_s[0...13].length)))+data.to_s[0...13] #13 CUSIP Number 'cusip_num'
        if (form_fields['1a']) 
            data = form_fields['1a'];
        else 
            data = ' ';
        end
        returned_data += data + (" "*(39-(data.to_s[0...39].length))).to_s[0...39] #39 Description of Property
        if (form_fields['1b']) 
            data = form_fields['1b'];
        else 
            data = ' ';
        end
        returned_data += data + (" "*(8-(data.to_s[0...8].length))).to_s[0...8] #8 Date Acquired TODO :MAKE IT TO BE  A DATE FIELD IN THE FORM!!
        if (form_fields['7']='checked') 
            data = '1';
        else
            data = ' ';
        end
        returned_data +=  data #1 Loss Not Allowed Indicator  '7'
        if (form_fields['app_checkbox']) 
            data = form_fields['app_checkbox'];
        else
            data = ' ';
        end
        returned_data +=  data #1 Applicable check box of Form 8949 'app_checkbox' value can be A,B,D,E,X or blank
        if (form_fields['12']=='checked') 
            data = '1'
        else
            data = ' ';
        end
        returned_data +=  data #1 Applicable checkbox for Collectables  '12'
        if (form_fields['fatca_fil_req']=='checked') 
            data = '1';
        else
            data = ' ';
        end
        returned_data +=  data #1 FATCA Filing Requirement Indicator  'fatca_fil_req'
        returned_data += " "*43 #43 blanks
        returned_data += " "*60 #60 Special Data Entries
        if (form_fields['state_tax_withheld']) 
            data = form_fields['state_tax_withheld']; #TODO: remove dot or dollar sign 
        else
            data = '0';
        end 
        returned_data += ("0"*(12-(data.to_s[0...12].length))) + data.to_s[0...12] #12  State Income Tax Withheld TODO: THIS SHOULD CLEANED FROM dots and dollar sign 
        returned_data += " "*12 #12 Local Income Tax Withheld
        returned_data += " "*2 #2 Combined Federal/State Code
        returned_data += "\r\n"


=begin
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
        if (form_fields['1a']) 
            description_of_property = form_fields['1a'].strip;
        else
            description_of_property = ' ';
        end
        returned_data += description_of_property.to_s + (" "*(39-(description_of_property.to_s.length))) #39

        returned_data += " "*68 #68 blanks
        returned_data += " "*60 #60 special data entries or blanks 
        returned_data += " "*26 #26 blanks
        returned_data += " "*2 #2 blanks
=end 
# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 234579ABCD 
        returned_data += "0"*18 #Payment Amount 1*
        if (form_fields['1d'])
            data_amount = sprintf('%.2f', form_fields['1d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 2, Proceeds (For forward contracts)
        end
        if (form_fields['1e'])
            data_amount = sprintf('%.2f', form_fields['1e'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 3 Cost or other basis
        end
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 4 Federal income tax withheld (backup withholding). Do not report negative amounts.
        end
        if (form_fields['1g'])
            data_amount = sprintf('%.2f', form_fields['1g'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 5 Wash Sale Loss Disallowed
        end
        returned_data += "0"*18 #Payment Amount 6*
        if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 7 Bartering
        end
        returned_data += "0"*18 #Payment Amount 8* 
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 9 Profit (or loss) realized in 2017 
        end
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount A Unrealized profit (or loss) on open contracts 18/31/2016 
        end
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount B Unrealized profit (or loss) on open contracts 12/31/2017
        end
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount C Aggregate profit (or loss)
        end
        if (form_fields['1f'])
            data_amount = sprintf('%.2f', form_fields['1f'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount D Accrued Market Discount
        end
        returned_data += "0"*18 #Payment Amount E*
        returned_data += "0"*18 #Payment Amount F*
        returned_data += "0"*18 #Payment Amount G*
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end






       def exportForm1099c(form_fields)
    #only for Form 1099c
        form_fields['creditors_fin'] ||= " "       

        form_fields['creditors_name_address'] ||= " "
        if form_fields['creditors_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address'].lines.first
        end
        if form_fields['creditors_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['creditors_name_address'].lines.second
        end
        if form_fields['creditors_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['creditors_name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['creditors_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['creditors_fin'].to_s[0...9] + (" "*(9-(form_fields['creditors_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "5 " #type of return "5 " " for 1099-C

        returned_data += "237             " #16 amount codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['creditors_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address'].lines.first
        end
        if form_fields['creditors_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['creditors_name_address'].lines.second
        end
        if form_fields['creditors_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['creditors_name_address'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['debtors_name'])
            returned_data += form_fields['debtors_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['debtors_id'])
            data_tin = form_fields['debtors_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_num']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 237 
        returned_data += "0"*12 #Payment Amount 1*
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 2, Amount of debt discharged
        end
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 3,Interest included in Amount Code 2 
        end
        returned_data += "0"*12 #Payment Amount 4*
        returned_data += "0"*12 #Payment Amount 5*
        returned_data += "0"*12 #Payment Amount 6*
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 7, Fair market value of property.
        end
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
        if (form_fields['debtors_name'])
            data_payee_name = form_fields['debtors_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099c 
        returned_data += " "*3 #3 blanks
        if (form_fields['6']) 
            data = form_fields['6'];
        else 
            data = ' ';
        end
        returned_data += data #1 identifiable event code '6' text box TODO: validation needed , these values are correct : 'A','B','C','D','E','F','G','H','I'
        if (form_fields['1']) 
            data = form_fields['1'];
        else 
            data = ' '*8;
        end
        returned_data += data #8 Date of Identifiable event '1' date box
        if (form_fields['4']) 
            data = form_fields['4'];
        else 
            data = ' '*39;
        end
        returned_data += data.to_s[0...39]+(" "*(39-(data.to_s[0...39].length))) #39 Debt Description '4' text
        if (form_fields['5']=='checked') 
            data = '1';
        else
            data = ' ';
        end
        returned_data +=  data #1 Personaly Liability Indicator '5' checkbox 1 for checked blank for not
        returned_data += " "*67 #67 blanks
        returned_data += " "*60 #60 special data entries or blanks
        returned_data += " "*26 #26 blanks
        returned_data += "\r\n"

# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 237
        returned_data += "0"*18 #Payment Amount 1*
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 2, Amount of debt discharged
        end
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 3,Interest included in Amount Code 2 
        end
        returned_data += "0"*18 #Payment Amount 4*
        returned_data += "0"*18 #Payment Amount 5*
        returned_data += "0"*18 #Payment Amount 6*
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 7, Fair market value of property.
        end
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
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end








    def exportForm1099cap(form_fields)

    #only for Form 1099cap
        form_fields['corporations_name_address'] ||= " "       

        form_fields['corporations_name_address'] ||= " "
        if form_fields['corporations_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['corporations_name_address'].lines.first
        end
        if form_fields['corporations_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['corporations_name_address'].lines.second
        end
        if form_fields['corporations_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['corporations_name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['corporations_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['corporations_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['corporations_fin'].to_s[0...9] + (" "*(9-(form_fields['corporations_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "P " #type of return "5 " " for 1099-C

        returned_data += "2               " #16 amount codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['corporations_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['corporations_name_address'].lines.first
        end
        if form_fields['corporations_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['corporations_name_address'].lines.second
        end
        if form_fields['corporations_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['corporations_name_address'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['shareholders_name'])
            returned_data += form_fields['shareholders_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['shareholders_id'])
            data_tin = form_fields['shareholders_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 2
        returned_data += "0"*12 #Payment Amount 1*XXXX
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 2XXXX
        end
        returned_data += "0"*12 #Payment Amount 3*XXXX
        returned_data += "0"*12 #Payment Amount 4*XXXX
        returned_data += "0"*12 #Payment Amount 5*XXXX
        returned_data += "0"*12 #Payment Amount 6*XXXX
        returned_data += "0"*12 #Payment Amount 7*XXXX
        returned_data += "0"*12 #Payment Amount 8*XXXX
        returned_data += "0"*12 #Payment Amount 9*XXXX
        returned_data += "0"*12 #Payment Amount A*XXXX
        returned_data += "0"*12 #Payment Amount B*XXXX
        returned_data += "0"*12 #Payment Amount C*XXXX
        returned_data += "0"*12 #Payment Amount D*XXXX
        returned_data += "0"*12 #Payment Amount E*XXXX
        returned_data += "0"*12 #Payment Amount F*XXXX
        returned_data += "0"*12 #Payment Amount G*XXXX
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['shareholders_name'])
            data_payee_name = form_fields['shareholders_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_or_town']) 
            city_town_state = form_fields['city_or_town'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099-CAP
        returned_data += " "*4 #4 blanks
        if (form_fields['4']) 
            data = form_fields['4'];
        else 
            data = '        ';
        end
        returned_data += data #8 date of sale or exchange, YYYYMMDD format '1'
        returned_data += " "*52 #52 blanks
        returned_data += ("0"*(8-(form_fields['3'].to_s[0...8].length)))+form_fields['3'].to_s[0...8] #8 number of shares exchanged, right justify fill with zeros, only numbers '3'
        returned_data += form_fields['4'].to_s[0...10]+(" "*(10-(form_fields['4'].to_s[0...10].length))) #10 classes of stock exchange left justify '4'
        returned_data += " "*37 #37 blanks
        returned_data += " "*60 #60 special data entries text
        returned_data += " "*26 #26 blanks
        returned_data += "\r\n"
# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 2
        returned_data += "0"*18 #Payment Amount 1*
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 2
        end
        returned_data += "0"*18 #Payment Amount 3*
        returned_data += "0"*18 #Payment Amount 4*
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
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end











def exportForm1099div(form_fields)
    #only for Form 1099div
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
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['payers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4


        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['payers_fin'].to_s[0...9] + (" "*(9-(form_fields['payers_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "1 " #type of return "1  for 1099-DIV

        returned_data += "1236789ABCDEFG  " #16 amount codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
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
        #end of reset
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name'])
            returned_data += form_fields['recipients_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 1236789ABCDEFG
        if (form_fields['1a'])
            data_amount = sprintf('%.2f', form_fields['1a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end    #Total ordinary dividends '1a'
        if (form_fields['1b'])
            data_amount = sprintf('%.2f', form_fields['1b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 2*Qualified dividends '1b'
        if (form_fields['2a'])
            data_amount = sprintf('%.2f', form_fields['2a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end  #Payment Amount 3*Total capital gain distribution '2a'

        returned_data += "0"*12 #Payment Amount 4
        returned_data += "0"*12 #Payment Amount 5

        if (form_fields['2b'])
            data_amount = sprintf('%.2f', form_fields['2b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 6*Unrecaptured Section 1250 gain '2b'
        if (form_fields['2c'])
            data_amount = sprintf('%.2f', form_fields['2c'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 7*Section 1202 gain '2c'
        if (form_fields['2d'])
            data_amount = sprintf('%.2f', form_fields['2d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 8*Collectibles (28%) rate gain '2d'
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 9*Nondividend distributions '3'
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount A*Federal income tax withheld '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount B*Investment expenses '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount C*Foreign tax paid '6'
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount D*Cash liquidation distributions '8'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount E*Non-cash liquidation distributions '9'
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount F*Exempt interest dividends '10'
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount G*Specified private activity bond interest dividends '11'
        
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['recipients_name'])
            data_payee_name = form_fields['recipients_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
        #these records are specifed for form 1099div
        if (form_fields['2nd_tin_not']=='checked') 
            data = '1';
        else
            data = ' ';
        end
        returned_data += data #1 Second TIN Notice '2nd_tin_not' - checked 1 , unchecked blank
        returned_data += " "*2 #2 blanks
        if (form_fields['7']) 
            data = form_fields['7'];
        else 
            data = ' ';
        end
        returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 Foreign Country or U.S. Possession '7'
        if (form_fields['fatca_filing_req']=='checked') 
            data = '1';
        else
            data = ' ';
        end
        returned_data += data #1 FATCA Filing Requirement Indicator 'fatca_filing_req'
        returned_data += " "*75 #75 blanks
        returned_data += " "*60 #60 Special Data Entries
        if (form_fields['14']) 
            data = form_fields['14'];
        else 
            data = ' ';
        end
        returned_data += ("0"*(12-(data.to_s[0...12].length)))+data.to_s[0...12] #12 State Income Tax Withheld '14'
        returned_data += "0" * 12 #12 Local Income Tax Withheld
        returned_data += " "*2 #2 Combined Federal/State Code
        returned_data += "\r\n"
# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 1236789ABCDEFG
        if (form_fields['1a'])
            data_amount = sprintf('%.2f', form_fields['1a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end    #Total ordinary dividends '1a'
        if (form_fields['1b'])
            data_amount = sprintf('%.2f', form_fields['1b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 2*Qualified dividends '1b'
        if (form_fields['2a'])
            data_amount = sprintf('%.2f', form_fields['2a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end  #Payment Amount 3*Total capital gain distribution '2a'

        returned_data += "0"*18 #Payment Amount 4
        returned_data += "0"*18 #Payment Amount 5

        if (form_fields['2b'])
            data_amount = sprintf('%.2f', form_fields['2b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 6*Unrecaptured Section 1250 gain '2b'
        if (form_fields['2c'])
            data_amount = sprintf('%.2f', form_fields['2c'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 7*Section 1202 gain '2c'
        if (form_fields['2d'])
            data_amount = sprintf('%.2f', form_fields['2d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 8*Collectibles (28%) rate gain '2d'
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 9*Nondividend distributions '3'
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount A*Federal income tax withheld '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount B*Investment expenses '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount C*Foreign tax paid '6'
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount D*Cash liquidation distributions '8'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount E*Non-cash liquidation distributions '9'
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount F*Exempt interest dividends '10'
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount G*Specified private activity bond interest dividends '11'



        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end







def exportForm1099g(form_fields)
    #only for Form 1099g
        form_fields['payers_fin'] ||= " "       

        form_fields['payers__name_address'] ||= " "
        if form_fields['payers__name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers__name_address'].lines.first
        end
        if form_fields['payers__name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['payers__name_address'].lines.second
        end
        if form_fields['payers__name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['payers__name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['payers__name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers__name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
       # returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
       # returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
       # returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['payers_fin'].to_s[0...9] + (" "*(9-(form_fields['payers_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "F " #type of return F for 1099-g

        returned_data += "1245678         " #16 amount codes
        #-1 Unemployment compensation
        #-2 State or local income tax refunds,credits, or offsets
        #-4 Federal income tax withheld (backup withholding or voluntary withholding on unemployment compensation of Commodity Credit Corporation Loans or certain crop disaster payments)
        #-5 Reemployment Trade Adjustment Assistance (RTAA) programs
        #-6 Taxable grants
        #-7 Agriculture payments
        #-8 Market gain

        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['payers__name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers__name_address'].lines.first
        end
        if form_fields['payers__name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['payers__name_address'].lines.second
        end
        if form_fields['payers__name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['payers__name_address'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name'])
            returned_data += form_fields['recipients_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 1245678
        #-1 Unemployment compensation
        #-2 State or local income tax refunds,credits, or offsets
        #-4 Federal income tax withheld (backup withholding or voluntary withholding on unemployment compensation of Commodity Credit Corporation Loans or certain crop disaster payments)
        #-5 Reemployment Trade Adjustment Assistance (RTAA) programs
        #-6 Taxable grants
        #-7 Agriculture payments
        #-8 Market gain
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end #Payment Amount 1*XXXX Unemployment compensation '1'
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end #Payment Amount 2*XXXX State or local income tax refunds,credits, or offsets '2'
        returned_data += "0"*12 #Payment Amount 3*XXXX
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end  #Payment Amount 4*XXXX Federal income tax withheld (backup withholding or voluntary withholding on unemployment compensation of Commodity Credit Corporation Loans or certain crop disaster payments) '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end  #Payment Amount 5*XXXX Reemployment Trade Adjustment Assistance (RTAA) programs '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end  #Payment Amount 6*XXXX Taxable grants '6'
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end  #Payment Amount 7*XXXX Agriculture payments '7'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12
        end  #Payment Amount 8*XXXX Market gain '9'
        returned_data += "0"*12 #Payment Amount 9*XXXX
        returned_data += "0"*12 #Payment Amount A*XXXX
        returned_data += "0"*12 #Payment Amount B*XXXX
        returned_data += "0"*12 #Payment Amount C*XXXX
        returned_data += "0"*12 #Payment Amount D*XXXX
        returned_data += "0"*12 #Payment Amount E*XXXX
        returned_data += "0"*12 #Payment Amount F*XXXX
        returned_data += "0"*12 #Payment Amount G*XXXX
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['recipients_name'])
            data_payee_name = form_fields['recipients_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099g 
        returned_data += " "*3 #3 blanks
        if (form_fields['8']=='checked') 
            data = '1';
        else
            data = ' ';
        end 
        returned_data += data #1 Trade or Business Indicator '8' checkbox 1 or blank
        if (form_fields['3']) 
            data = ("0"*(4-(form_fields['3'].to_s[0...4].length)))+form_fields['3'].to_s[0...4]
        else
            data = ' '*4 #TODO: all these fields  needs validation!!
        end
        returned_data += data #4 Tax Year of Refund '3' 
        returned_data += " "*111 #111 blanks
        returned_data += " "*60 #60 Special Data Entries
        if (form_fields['11']) 
            data = form_fields['11'];
        else
            data = '0' #TODO: needs validation , remove dots and dollar sign 
        end
        returned_data +=   ("0"*(12-(data.to_s[0...12].length)))+data.to_s[0...12]  #12 State Income Tax Withheld '11', filled in zeros right justified
        returned_data += "0"*12 #12 Local Income Tax Withheld
        returned_data += " "*2 #2 Combined Federal/ State Code
        returned_data += "\r\n"

=begin  returned_data += " "*3 #3 blanks
        if (form_fields['6']) 
            data = form_fields['6'];
        else 
            data = ' ';
        end
=end
# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 1245678
        #-1 Unemployment compensation
        #-2 State or local income tax refunds,credits, or offsets
        #-4 Federal income tax withheld (backup withholding or voluntary withholding on unemployment compensation of Commodity Credit Corporation Loans or certain crop disaster payments)
        #-5 Reemployment Trade Adjustment Assistance (RTAA) programs
        #-6 Taxable grants
        #-7 Agriculture payments
        #-8 Market gain
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end #Payment Amount 1*XXXX Unemployment compensation '1'
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end #Payment Amount 2*XXXX State or local income tax refunds,credits, or offsets '2'
        returned_data += "0"*18 #Payment Amount 3*XXXX
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end  #Payment Amount 4*XXXX Federal income tax withheld (backup withholding or voluntary withholding on unemployment compensation of Commodity Credit Corporation Loans or certain crop disaster payments) '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end  #Payment Amount 5*XXXX Reemployment Trade Adjustment Assistance (RTAA) programs '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end  #Payment Amount 6*XXXX Taxable grants '6'
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end  #Payment Amount 7*XXXX Agriculture payments '7'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end  #Payment Amount 8*XXXX Market gain '9'
        returned_data += "0"*18 #Payment Amount 9*XXXX
        returned_data += "0"*18 #Payment Amount A*XXXX
        returned_data += "0"*18 #Payment Amount B*XXXX
        returned_data += "0"*18 #Payment Amount C*XXXX
        returned_data += "0"*18 #Payment Amount D*XXXX
        returned_data += "0"*18 #Payment Amount E*XXXX
        returned_data += "0"*18 #Payment Amount F*XXXX
        returned_data += "0"*18 #Payment Amount G*XXXX
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end







def exportForm1099h(form_fields)
    #only for Form 1099h
        form_fields['issuers_providers_fin'] ||= " "       

        form_fields['issuers_providers_name_address'] ||= " "
        if form_fields['issuers_providers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['issuers_providers_name_address'].lines.first
        end
        if form_fields['issuers_providers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['issuers_providers_name_address'].lines.second
        end
        if form_fields['issuers_providers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['issuers_providers_name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932';
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['issuers_providers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['issuers_providers_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['issuers_providers_fin'].to_s[0...9] + (" "*(9-(form_fields['issuers_providers_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "J " #type of return "J " for 1099-H

        returned_data += "123456789ABCD   " #16 amount codes for Form 1099-H, Health Coverage Tax credit
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['issuers_providers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['issuers_providers_name_address'].lines.first
        end
        if form_fields['issuers_providers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['issuers_providers_name_address'].lines.second
        end
        if form_fields['issuers_providers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['issuers_providers_name_address'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name']) 
            returned_data += form_fields['recipients_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = rand(99999999999999999999).to_s #generate 20 random number 
        returned_data += data_account.to_s[0...20]+ (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 123456789ABCD  
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-1 Gross amount of health insurance advance payments '1'
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-2 Gross amount of health insurance payments for January '3'
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-3 Gross amount of health insurance payments for February '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-4 Gross amount of health insurance payments for March '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-5 Gross amount of health insurance payments for April '6'
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-6 Gross amount of health insurance payments for May '7'
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-7 Gross amount of health insurance payments for June '8'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-8 Gross amount of health insurance payments for July '9'
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-9 Gross amount of health insurance payments for August '10'
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-A Gross amount of health insurance payments for September '11'
        if (form_fields['12'])
            data_amount = sprintf('%.2f', form_fields['12'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-B Gross amount of health insurance payments for October '12'
        if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-C Gross amount of health insurance payments for November '13'
        if (form_fields['14'])
            data_amount = sprintf('%.2f', form_fields['14'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #-D Gross amount of health insurance payments for December '14'
        returned_data += "0"*12 #Payment Amount E*XXXX
        returned_data += "0"*12 #Payment Amount F*XXXX
        returned_data += "0"*12 #Payment Amount G*XXX
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['recipients_name'])
            data_payee_name = form_fields['recipients_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town_address']) 
            city_town_state = form_fields['city_town_address'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099-H
        returned_data += " "*3 #3 blanks
        if (form_fields['2']) 
            data = form_fields['2'].strip;
        else
            data = ' ';
        end 
        returned_data +=  (" "*(2-(data.to_s[0...2].length)))+data.to_s[0...2] #2 Number of Months Eligible TODO: check with Sean does this field belongs to this record
        returned_data += " "*114 #114 blanks
        returned_data += " "*60 #60 Special Data Entries
        returned_data += " "*26 #26 blanks
        returned_data += "\r\n"
# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 123456789ABCD  
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-1 Gross amount of health insurance advance payments '1'
        if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-2 Gross amount of health insurance payments for January '3'
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-3 Gross amount of health insurance payments for February '4'
        if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-4 Gross amount of health insurance payments for March '5'
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-5 Gross amount of health insurance payments for April '6'
        if (form_fields['7'])
            data_amount = sprintf('%.2f', form_fields['7'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-6 Gross amount of health insurance payments for May '7'
        if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-7 Gross amount of health insurance payments for June '8'
        if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-8 Gross amount of health insurance payments for July '9'
        if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-9 Gross amount of health insurance payments for August '10'
        if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-A Gross amount of health insurance payments for September '11'
        if (form_fields['18'])
            data_amount = sprintf('%.2f', form_fields['18'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-B Gross amount of health insurance payments for October '18'
        if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-C Gross amount of health insurance payments for November '13'
        if (form_fields['14'])
            data_amount = sprintf('%.2f', form_fields['14'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #-D Gross amount of health insurance payments for December '14'
        returned_data += "0"*18 #Payment Amount E*XXXX
        returned_data += "0"*18 #Payment Amount F*XXXX
        returned_data += "0"*18 #Payment Amount G*XXX
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end










def exportForm1099int(form_fields)
    #only for Form 1099int
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
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist    
        

        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['payers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['payers_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
       # returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
       # returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
       # returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['payers_fin'].to_s[0...8] + (" "*(9-form_fields['payers_fin'].to_s[0...8].length)) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "6 " #type of return "6 "  for 1099-INT
        
        returned_data += "12345689ABDE    " #16 amount codes
        # 1-Interest income not included in Amount Code 3
        # 2-Early withdrawal penalty
        # 3-Interest on U.S. Savings Bonds and Treasury obligations
        # 4-Federal income tax withheld (backup withholding)
        # 5-Investment expenses
        # 6-Foreign tax paid
        # 8-Tax-exempt interest
        # 9-Specified private activity bond
        # A-Market discount
        # B-Bond premium
        # D-Bond premium on tax exempt bond
        # E-Bond Premium on Treasury Obligation
 
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
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
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['recipients_name'])
            returned_data += form_fields['recipients_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['recipients_id'])
            data_tin = form_fields['recipients_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #returned_data += "12345689ABDE    " #16 amount codes
      
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  1-Interest income not included in Amount Code 3 '1'
         if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  2-Early withdrawal penalty '2'
         if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  3-Interest on U.S. Savings Bonds and Treasury obligations '3'
         if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  4-Federal income tax withheld (backup withholding) '4'
         if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  5-Investment expenses '5'
         if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount  6-Foreign tax paid '6'
        returned_data += "0"*12 #Payment Amount 7*
         if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 8-Tax-exempt interest '8'
         if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount 9-Specified private activity bond '9'
         if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount A-Market discount '10'
         if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount B-Bond premium '11'
        returned_data += "0"*12 #Payment Amount C*
         if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount D-Bond premium on tax exempt bond '13'
         if (form_fields['12'])
            data_amount = sprintf('%.2f', form_fields['12'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 
        end #Payment Amount E-Bond Premium on Treasury Obligation '12'
        returned_data += "0"*12 #Payment Amount F*
        returned_data += "0"*12 #Payment Amount G*
        
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['recipients_name'])
            data_payee_name = form_fields['recipients_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
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
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099-int 
if (form_fields['2nd_tin_not']=='checked') 
    data = '2';
else
    data = ' ';
end 
returned_data += data #1 Second TIN Notice (Optional) '2nd_tin_not' can be 2 or blank
returned_data += " "*2 #2 blanks
returned_data += form_fields['7'] + (" "*(40-(form_fields['7'].to_s[0...40].length))) #40 Foreign Country or U.S. Possession '7' the name of the country or US possession or blank
returned_data += (" "*(13-(form_fields['14'].to_s[0...13].length)))+form_fields['14'].to_s[0...13] #13 CUSIP Number '14' If the tax-exempt interest is reported in the aggregate for multiple bonds or accounts, enter VARIOUS. Right justify the information and fill unused positions with blanks.
if (form_fields['fatca_filing_req']=='checked') 
    data = '1';
else
    data = ' ';
end 
returned_data += ' ' #1 FATCA Filing Requirement Indicator 'fatca_filing_req' one or blank
returned_data += " "*62 #62 Blank
returned_data += " "*60 #60 Special Data Entries
returned_data +=  ("0"*(12-(form_fields['17'].to_s[0...12].length)))+form_fields['17'].to_s[0...12] #12 State Income Tax Withheld '17' 
returned_data += " "*12 #12 Local Income Tax Withheld
returned_data += " "*2 #2 Combined Federal/State Code
returned_data += "\r\n"

# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        
        if (form_fields['1'])
            data_amount = sprintf('%.2f', form_fields['1'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount  1-Interest income not included in Amount Code 3 '1'
         if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount  2-Early withdrawal penalty '2'
         if (form_fields['3'])
            data_amount = sprintf('%.2f', form_fields['3'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end #Payment Amount  3-Interest on U.S. Savings Bonds and Treasury obligations '3'
         if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18
        end #Payment Amount  4-Federal income tax withheld (backup withholding) '4'
         if (form_fields['5'])
            data_amount = sprintf('%.2f', form_fields['5'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount  5-Investment expenses '5'
         if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount  6-Foreign tax paid '6'
        returned_data += "0"*18 #Payment Amount 7*
         if (form_fields['8'])
            data_amount = sprintf('%.2f', form_fields['8'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 8-Tax-exempt interest '8'
         if (form_fields['9'])
            data_amount = sprintf('%.2f', form_fields['9'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount 9-Specified private activity bond '9'
         if (form_fields['10'])
            data_amount = sprintf('%.2f', form_fields['10'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount A-Market discount '10'
         if (form_fields['11'])
            data_amount = sprintf('%.2f', form_fields['11'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount B-Bond premium '11'
        returned_data += "0"*18 #Payment Amount C*
         if (form_fields['13'])
            data_amount = sprintf('%.2f', form_fields['13'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount D-Bond premium on tax exempt bond '13'
         if (form_fields['12'])
            data_amount = sprintf('%.2f', form_fields['12'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 
        end #Payment Amount E-Bond Premium on Treasury Obligation '12'
        returned_data += "0"*18 #Payment Amount F*
        returned_data += "0"*18 #Payment Amount G*
        
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end







    def exportForm1099k(form_fields)
    #only for Form 1099k
        form_fields['filers_fin'] ||= " "       

        form_fields['filers_name_street'] ||= " "
        if form_fields['filers_name_street'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_street'].lines.first
        end
        if form_fields['filers_name_street'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['filers_name_street'].lines.second
        end
        if form_fields['filers_name_street'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['filers_name_street'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += " "*7 #7 characters - blank
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['filers_name_street'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_street'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4

        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['filers_fin'].to_s[0...9] + (" "*(9-(form_fields['filers_fin'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "MC" #type of return "MC" for 1099-K

        returned_data += "12456789ABCDEFG " #16 amount codes
        # -1 Gross amount of payment card/third party network transactions 
        # -2 Card not present transactions
        # -4 Federal Income tax withheld
        # - 5 January payment
        # - 6 February payments
        # - 7 March payments
        # - 8 April payments
        # - 9 May payments
        # - A June payments
        # - B July payments
        # - C August payments
        # - D September payments
        # - E October payments
        # - F November payments
        # - G December payments
 
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
         if form_fields['filers_name_street'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_street'].lines.first
        end
        if form_fields['filers_name_street'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['filers_name_street'].lines.second
        end
        if form_fields['filers_name_street'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['filers_name_street'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5.to_s[0...40] + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['payees_name'])
            returned_data += form_fields['payees_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['payees_taxpayer'])
            data_tin = form_fields['payees_taxpayer'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_num']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 12456789ABCDEFG 
        # -1 
        # -2 
        # -4 
        # - 5 
        # - 6 
        # - 7 
        # - 8 
        # - 9 
        # - A 
        # - B 
        # - C 
        # - D 
        # - E 
        # - F 
        # - G 
        #stao sam ovde
        if (form_fields['1a'])
            data_amount = sprintf('%.2f', form_fields['1a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 1 Gross amount of payment card/third party network transactions '1a'
        if (form_fields['1b'])
            data_amount = sprintf('%.2f', form_fields['1b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 2 Card not present transactions '1b'
        returned_data += "0"*12 #Payment Amount 3
        if (form_fields['4'])
            data_amount = sprintf('%.2f', form_fields['4'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 4 Federal Income tax withheld '4'
        if (form_fields['5a'])
            data_amount = sprintf('%.2f', form_fields['5a'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 5 January payment '5a'
        if (form_fields['5b'])
            data_amount = sprintf('%.2f', form_fields['5b'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 6 February payments '5b'
        if (form_fields['5c'])
            data_amount = sprintf('%.2f', form_fields['5c'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 7 March payments '5c'
        if (form_fields['5d'])
            data_amount = sprintf('%.2f', form_fields['5d'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 8 April payments '5d'
        if (form_fields['5e'])
            data_amount = sprintf('%.2f', form_fields['5e'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount 9 May payments '5e'
        if (form_fields['5f'])
            data_amount = sprintf('%.2f', form_fields['5f'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount A June payments '5f'
        if (form_fields['5g'])
            data_amount = sprintf('%.2f', form_fields['5g'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount B July payments '5g'
        if (form_fields['5h'])
            data_amount = sprintf('%.2f', form_fields['5h'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount C August payments '5h'
        if (form_fields['5i'])
            data_amount = sprintf('%.2f', form_fields['5i'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount D September payments '5i'
        if (form_fields['5j'])
            data_amount = sprintf('%.2f', form_fields['5j'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount E October payments '5j'
        if (form_fields['5k'])
            data_amount = sprintf('%.2f', form_fields['5k'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount F November payments '5k'
        if (form_fields['5l'])
            data_amount = sprintf('%.2f', form_fields['5l'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...20]
        else 
            returned_data += "0"*12
        end #Payment Amount G December payments '5l'
        returned_data += " " #blank if US citizen otherwise enter 1
    #stao sam ovde
        if (form_fields['debtors_nameXXX'])
            data_payee_name = form_fields['debtors_nameXXXX'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address_XXXX']) 
            street_address = form_fields['street_address_XXXX'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town_state_XXXX']) 
            city_town_state = form_fields['city_town_state_XXXX'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*34 #34 blanks
        returned_data += "\r\n"
#these records are specifed for form XXXX 
=begin  returned_data += " "*3 #3 blanks
        if (form_fields['6']) 
            data = form_fields['6'];
        else 
            data = ' ';
        end
=end
# Payer C record (control record)

        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 237XXX
        #payment amounts 237XXXXX
        returned_data += "0"*18 #Payment Amount 1*XXXX
        if (form_fields['xxxx'])
            data_amount = sprintf('%.2f', form_fields['xxxx'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount.to_s[0...18]
        else 
            returned_data += "0"*18 #Payment Amount 2XXXX
        end
        returned_data += "0"*18 #Payment Amount 3*XXXX
        returned_data += "0"*18 #Payment Amount 4*XXXX
        returned_data += "0"*18 #Payment Amount 5*XXXX
        returned_data += "0"*18 #Payment Amount 6*XXXX
        returned_data += "0"*18 #Payment Amount 7*XXXX
        returned_data += "0"*18 #Payment Amount 8*XXXX
        returned_data += "0"*18 #Payment Amount 9*XXXX
        returned_data += "0"*18 #Payment Amount A*XXXX
        returned_data += "0"*18 #Payment Amount B*XXXX
        returned_data += "0"*18 #Payment Amount C*XXXX
        returned_data += "0"*18 #Payment Amount D*XXXX
        returned_data += "0"*18 #Payment Amount E*XXXX
        returned_data += "0"*18 #Payment Amount F*XXXX
        returned_data += "0"*18 #Payment Amount G*XXX
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end

   ################################ GENERIC ###############################################

   def exportForm1099xxx(form_fields)
    #only for Form 1099xxx
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        form_fields['creditors_fin_XXXXX'] ||= " "       

        form_fields['creditors_name_address_XXXXX'] ||= " "
        if form_fields['creditors_name_address_XXXXX'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address_XXXXX'].lines.first
        end
        if form_fields['creditors_name_address_XXXXXX'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['creditors_name_address_XXXXXX'].lines.second
        end
        if form_fields['creditors_name_address_XXXX'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['creditors_name_address_XXXX'].lines.third
        end
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += form_fields['creditors_fin_XXXX'].to_s[0...9] + (" "*(9-(form_fields['creditors_fin_XXXX'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        
        returned_data += '111111111';
        returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1
        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        if form_fields['creditors_name_address_XXXXX'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address_XXXXX'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        data = second_line.strip              
        returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'TEST TEST                               ';#40 characters
        returned_data += '1111111111     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['creditors_fin_XXXX'].to_s[0...9] + (" "*(9-(form_fields['creditors_fin_XXXX'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "XXXX " #type of return "XXX " " for 1099-X

        returned_data += "237XXXX           " #16 amount codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['creditors_name_address_XXXXX'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['creditors_name_address_XXXXX'].lines.first
        end
        if form_fields['creditors_name_address_XXXXXX'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['creditors_name_address_XXXXXX'].lines.second
        end
        if form_fields['creditors_name_address_XXXX'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['creditors_name_address_XXXX'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += '5107062877     ' #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += '2017' #lenght 4
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['debtors_name_XXXX'])
            returned_data += form_fields['debtors_name_XXXXX'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['debtors_id_XXXXX'])
            data_tin = form_fields['debtors_id_XXXX'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_num_XXXX']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 237XXXXX
        returned_data += "0"*12 #Payment Amount 1*XXXX
        if (form_fields['xxxx'])
            data_amount = sprintf('%.2f', form_fields['xxxx'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 2XXXX
        end
        returned_data += "0"*12 #Payment Amount 3*XXXX
        returned_data += "0"*12 #Payment Amount 4*XXXX
        returned_data += "0"*12 #Payment Amount 5*XXXX
        returned_data += "0"*12 #Payment Amount 6*XXXX
        returned_data += "0"*12 #Payment Amount 7*XXXX
        returned_data += "0"*12 #Payment Amount 8*XXXX
        returned_data += "0"*12 #Payment Amount 9*XXXX
        returned_data += "0"*12 #Payment Amount A*XXXX
        returned_data += "0"*12 #Payment Amount B*XXXX
        returned_data += "0"*12 #Payment Amount C*XXXX
        returned_data += "0"*12 #Payment Amount D*XXXX
        returned_data += "0"*12 #Payment Amount E*XXXX
        returned_data += "0"*12 #Payment Amount F*XXXX
        returned_data += "0"*12 #Payment Amount G*XXXX
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['debtors_nameXXX'])
            data_payee_name = form_fields['debtors_nameXXXX'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name.to_s[0...40] + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address_XXXX']) 
            street_address = form_fields['street_address_XXXX'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town_state_XXXX']) 
            city_town_state = form_fields['city_town_state_XXXX'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_sliced = city_town_state.slice! zip
        city = city_town_state_sliced.slice! state  
        city = " " if city.blank?  
       
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*34 #36 blanks
#these records are specifed for form XXXX 
=begin  returned_data += " "*3 #3 blanks
        if (form_fields['6']) 
            data = form_fields['6'];
        else 
            data = ' ';
        end
=end

# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 237XXX
        #payment amounts 237XXXXX
        returned_data += "0"*18 #Payment Amount 1*XXXX
        if (form_fields['xxxx'])
            data_amount = sprintf('%.2f', form_fields['xxxx'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount
        else 
            returned_data += "0"*18 #Payment Amount 2XXXX
        end
        returned_data += "0"*18 #Payment Amount 3*XXXX
        returned_data += "0"*18 #Payment Amount 4*XXXX
        returned_data += "0"*18 #Payment Amount 5*XXXX
        returned_data += "0"*18 #Payment Amount 6*XXXX
        returned_data += "0"*18 #Payment Amount 7*XXXX
        returned_data += "0"*18 #Payment Amount 8*XXXX
        returned_data += "0"*18 #Payment Amount 9*XXXX
        returned_data += "0"*18 #Payment Amount A*XXXX
        returned_data += "0"*18 #Payment Amount B*XXXX
        returned_data += "0"*18 #Payment Amount C*XXXX
        returned_data += "0"*18 #Payment Amount D*XXXX
        returned_data += "0"*18 #Payment Amount E*XXXX
        returned_data += "0"*18 #Payment Amount F*XXXX
        returned_data += "0"*18 #Payment Amount G*XXX
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end








    ######################### 1099s ##########################
    def exportForm1099s(form_fields)
    #only for Form 1099s
        form_fields['filers_fid'] ||= " "       

        form_fields['filers_name_address'] ||= " "
        if form_fields['filers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_address'].lines.first
        end
        if form_fields['filers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['filers_name_address'].lines.second
        end
        if form_fields['filers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['filers_name_address'].lines.third
        end
    #1st 750 records - Transmitter “T” Record
        #set all form fields to blank if the are not exist
        
        returned_data = 'T' #begining of the file -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' # P if it is for prior year otherwise blank -lenght 1

        returned_data += '473852932' #9 characters - Transmitter'S federal identification number
        #returned_data += '11111' + (" "*(5-('11111'.to_s[0...5].length))) #5 characters - Transmitter Control Code
        returned_data += '93A66'        
        returned_data += ' '*7
        returned_data += ' ' # T if it is a test file otherwise blank -lenght 1
        returned_data += ' ' #Enter a “1” (one) if the transmitter is a foreign entity otherwise blank -lenght 1 TODO: There is a field in the form for this use it !!! see what impact that 
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data.to_s[0...40] + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify.
        returned_data += ' '*40
        if form_fields['filers_name_address'].lines.first.blank?
           first_line = "_"
        else 
           first_line = form_fields['filers_name_address'].lines.first
        end
        data = first_line.strip.truncate_words(2,omission: '')
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += 'CODE ACCOUNTING'+ ' '*25
        data2 = first_line
        data2.slice! data
        data2 = data2.strip
        #returned_data += data2 + (" "*(40-(data2.to_s[0...40].length))) #40 characters - transmitter aditional data. Left justify. 
        returned_data += ' '*40
        data = second_line.strip              
        #returned_data += data + (" "*(40-(data.to_s[0...40].length))) #40 characters Requered
        returned_data += '249 W. JACKSON STREET STE 260'+' '*11
        third_line.delete! ',/-'
        data = third_line.strip 
        data = " " if data.blank?
        data_array =  data.split(/\W+/)   
        data_zip = data_array[-1]
        data_zip = " " if data_zip.blank?
        data_zip = data_zip[0...8] if data_zip.length>9 
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0...1] if data_state.length>2
        data.slice! data_zip
        data.slice! data_state  
        data_city = data
        data_city = " " if data_city.blank?
        #returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 characters Requered
        #returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 characters Requered
        #returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 characters Requered
        returned_data += 'Hayward'+' '*33
        returned_data += 'CA'
        returned_data += '94544'+' '*4


        returned_data += " "*15 #15 blank characters 
        returned_data += '00000001' #8 characters Total Number of Payees
        returned_data += 'SEAN ALLABAND                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
    #359-408       
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 
    #409-499
        returned_data += " "*91 #91 characters - blank
    #500-507
        returned_data += "00000001"; # number of the record T record is always first 8 characters
    #508-517
        returned_data += " "*10 #blanks
        returned_data += "I" #vendor indicator I if there are no vendor
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
        returned_data += "\r\n" 
#2nd 750 records - Payer "A" Record
        returned_data += 'A' #begining of the record -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' #lenght 1 is this CF/SF Program ? 1 if it is otherwise blank
        returned_data += " "*5 #blanks
        returned_data += form_fields['filers_fid'].to_s[0...9] + (" "*(9-(form_fields['filers_fid'].to_s[0...9].length))) #9 characters - TRANSFEROR'S federal identification number
        #first four characters of the payer last name
        returned_data += " "*4 #blanks of first four characters of the payers last name
        returned_data += " " #blank if this is not last year the payer name will file info returns electro or on paper
        returned_data += "S " #type of return "XXX " " for 1099-X

        returned_data += "25              " #16 amount codes
        returned_data += " "*8 #blanks
        returned_data += " " #blank if payer is US citizen 
        if form_fields['filers_name_address'].lines.first.blank?
            first_line = "_"
        else 
            first_line = form_fields['filers_name_address'].lines.first
        end
        if form_fields['filers_name_address'].lines.second.blank?
            second_line = "_"
        else 
            second_line = form_fields['filers_name_address'].lines.second
        end
        if form_fields['filers_name_address'].lines.third.blank?
            third_line = "_"
        else 
            third_line = form_fields['filers_name_address'].lines.third
        end
        data5 = first_line.strip.truncate_words(2,omission: '')
        returned_data += data5 + (" "*(40-(data5.to_s[0...40].length))) #40 characters - transmitter name. Left justify.
        returned_data += " "*40 #blanks if there is no transfer agent otherwise the agent name 
        returned_data += "0" #if there is no transfer agent
        data6 = second_line.strip              
        returned_data += data6 + (" "*(40-(data6.to_s[0...40].length))) #the adress  of the payer if there is not transfer agent 40 characters Requered
        returned_data += data_city + (" "*(40-(data_city.to_s[0...40].length))) #40 payers city if there is not transfer agent
        returned_data += data_state.to_s[0...2] + (" "*(2-(data_state.to_s[0...2].length))) #2 payers state if there is not transfer agent
        returned_data += data_zip.to_s[0...9] + (" "*(9-(data_zip.to_s[0...9].length))) #9 payers zip if there is not transfer agent
        returned_data += " "*15 #15 payer’s telephone number - there are no such field in the form !!!
        returned_data += " "*260 #blanks
        returned_data += "00000002" #the second record
        returned_data += " "*241 #blanks
        returned_data += "\r\n"
#3th 750 records - Payer "B" Record - this Record contains the payment information from information returns.
        returned_data += 'B' #begining of the record -lenght 1
        returned_data += ((Date.today.year)-1).to_s #lenght 4 TODO: do this for other forms, also put an option later to choose the year then set the indicator about prior year bellow
        returned_data += ' ' #is this correction or not ? enter G or C if it is otherwise blank field
        if (form_fields['transferors_name'])
            returned_data += form_fields['transferors_name'].split.last[0...4] #employees_name the first four characters of the last name
        else 
            returned_data += "    "
        end
        returned_data += "2" #Type of TIN 2 is for an individual 
        if (form_fields['transferors_id'])
            data_tin = form_fields['transferors_id'].delete("^a-zA-Z0-9") 
        else 
            data_tin = ''
        end

        returned_data += data_tin.to_s[0...9] + (" "*(9-(data_tin.to_s[0...9].length))) #Payee’s Taxpayer Identification Number (TIN)
        data_account = form_fields['account_number']
        if (!data_account) 
           data_account = rand(99999999999999999999).to_s #generate 20 random number 
        end
        returned_data += data_account.to_s[0...20] + (" "*(20-(data_account.to_s[0...20].length))) 
        returned_data += " "*4 #blanks #Payer’s Office Code - you can enter blanks
        returned_data += " "*10 #blanks
        #payment amounts 25
        returned_data += "0"*12 #Payment Amount 1
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 2
        end
        returned_data += "0"*12 #Payment Amount 3
        returned_data += "0"*12 #Payment Amount 4
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(12-(data_amount.to_s[0...12].length)))+data_amount.to_s[0...12]
        else 
            returned_data += "0"*12 #Payment Amount 5
        end
        returned_data += "0"*12 #Payment Amount 6
        returned_data += "0"*12 #Payment Amount 7
        returned_data += "0"*12 #Payment Amount 8
        returned_data += "0"*12 #Payment Amount 9
        returned_data += "0"*12 #Payment Amount A
        returned_data += "0"*12 #Payment Amount B
        returned_data += "0"*12 #Payment Amount C
        returned_data += "0"*12 #Payment Amount D
        returned_data += "0"*12 #Payment Amount E
        returned_data += "0"*12 #Payment Amount F
        returned_data += "0"*12 #Payment Amount G
        returned_data += " " #blank if US citizen otherwise enter 1
        if (form_fields['transferors_name'])
            data_payee_name = form_fields['transferors_name'].split.last(2).join(" ") 
        else
            data_payee_name = ''
        end
        returned_data +=  data_payee_name.to_s[0...40] + (" "*(40-(data_payee_name.to_s[0...40].length))) #40 First payee name line -employees_name
        returned_data += " "*40 #40 Second payee name line
        returned_data += " "*40 #40 blanks
        if (form_fields['street_address']) 
            street_address = form_fields['street_address'].strip;
        else
            street_address = ' ';
        end
        returned_data +=  street_address + (" "*(40-(street_address.to_s[0...40].length))) #40 Payee mailing address
        returned_data += " "*40 #40 blanks
                
        if (form_fields['city_town_state']) 
            city_town_state = form_fields['city_town_state'].strip;
        else
            city_town_state = ' ';
        end
        city_town_state = " " if city_town_state.blank?
        city_town_state_array =  city_town_state.split(/\W+/)   
        city_town_state_joined = city_town_state_array.join(' ')
        zip = city_town_state_array[-1]
        zip = " " if zip.blank?
        zip = zip[0...8] if zip.length>9 
        state = city_town_state_array[-2]
        state = " " if state.blank?
        state = state[0...1] if state.length>2
        city_town_state_joined.slice!(zip)
        city_town_state_joined.slice!(city_town_state_array[-2])
        city = city_town_state_joined
        city = " " if city.blank?  
        #TODO CHANGE ABOVE FOR ALL FORMS also make possibility for admins to change the Form and to save     
        returned_data +=  city + (" "*(40-(city.to_s[0...40].length))) #40 payee city , town or postal office (do not enter zip)
        returned_data +=  state.to_s[0...2] + (" "*(2-(state.to_s[0...2].length)))#2 valid U.S Postal Service state
        returned_data +=  zip.to_s[0...9] + (" "*(9-(zip.to_s[0...9].length)))#9 Payee ZIP code
        returned_data += " " # blank

        returned_data += "00000003" #8 Record Sequence Number
        returned_data += " "*36 #36 blanks
#these records are specifed for form 1099s 
        returned_data += " "*3 #3 blanks
        #property of services indicator 1 or blank
        if (form_fields['4']=='checked') 
            data = '1'
        else 
            data = ' '
        end
        returned_data += data
        #date of closing 8 YYYYMMDD
        returned_data += form_fields['1'] 
        #address or Legal Description 39 left with blanks
        returned_data +=  form_fields['3'] + (" "*(39-(form_fields['3'].to_s[0...39].length)))
        #Blank 68
        returned_data += " "*68 #68 blanks
        #special or blank 60
        returned_data += " "*60 #60 blanks
        returned_data += " "*12 #12 blanks
        returned_data += " "*12 #12 blanks
        returned_data += " "*2 #2 blanks
        returned_data += "\r\n"


# Payer C record (control record)
        returned_data += 'C' # enter C
        returned_data += '00000001' #8 total number of payees
        returned_data += ' '*6 #6 blanks

        #payment amounts 25
        returned_data += "0"*18 #Payment Amount 1
        if (form_fields['2'])
            data_amount = sprintf('%.2f', form_fields['2'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount
        else 
            returned_data += "0"*18 #Payment Amount 2XXXX
        end
        returned_data += "0"*18 #Payment Amount 3
        returned_data += "0"*18 #Payment Amount 4
        if (form_fields['6'])
            data_amount = sprintf('%.2f', form_fields['6'])
            data_amount = data_amount.tr('.', '')
            returned_data += ("0"*(18-(data_amount.to_s[0...18].length)))+data_amount
        else 
            returned_data += "0"*18 #Payment Amount 5
        end
        returned_data += "0"*18 #Payment Amount 6
        returned_data += "0"*18 #Payment Amount 7
        returned_data += "0"*18 #Payment Amount 8
        returned_data += "0"*18 #Payment Amount 9
        returned_data += "0"*18 #Payment Amount A
        returned_data += "0"*18 #Payment Amount B
        returned_data += "0"*18 #Payment Amount C
        returned_data += "0"*18 #Payment Amount D
        returned_data += "0"*18 #Payment Amount E
        returned_data += "0"*18 #Payment Amount F
        returned_data += "0"*18 #Payment Amount G
        returned_data += ' '*196 #196 blanks
        returned_data += "00000004" #8 Record Sequence Number
        returned_data += ' '*241 #241 blanks
        returned_data += "\r\n"
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
        returned_data += "\r\n"
#end of file
        return returned_data
    end
    ########################## end of 1099s ################################

end
