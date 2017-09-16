module AdminHelper
    def addT(form_fields)
    #only for Form 3921
        #1st 748 records - Transmitter “T” Record
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
        returned_data += '2016' #lenght 4
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
        data_state = data_array[-2]
        data_state = " " if data_state.blank?
        data_state = data_state[0..1] if data_state.length>2
        data_sliced = data.slice! data_zip
        data_city = data_sliced.slice! data_state  
        data_city = " " if data_city.blank?
        data_state = data_city[0..8] if data_state.length>9               
        returned_data += data_city + (" "*(40-(data_city.to_s.length))) #40 characters Requered
        returned_data += data_state + (" "*(2-(data_state.to_s.length))) #2 characters Requered
        returned_data += data_zip + (" "*(9-(data_zip.to_s.length))) #9 characters Requered
        returned_data += " "*15 #15 blank characters 
        returned_data += '00000004' #8 characters Total Number of Payees there is no such field in Form 3921
        returned_data += 'Sean Allaband                           ';#40 characters
        returned_data += '5107062877     ' #15 characters Requered
        returned_data += 'sean@codeaccounting.com                           ' #50 characters 



=begin
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
        returned_data += form_fields['X'] + (" "*(X-(data.to_s.length))) #X characters -X
=end
        #2nd 748 records
        #3rd 748 records
        #4th 748 records
        #5th 748 records
        #6th 748 records
        #7th 748 records
        #8th 748 records
        #9th 748 records
        #10th 748 records
        #11th 748 records
        #12th 748 records
        #13th 748 records
        #14th 748 records
        #15th 748 records
        #16th 748 records
        #17th 748 records
        #18th 748 records
        #19th 748 records
        #20th 748 records

        return returned_data
    end
end
