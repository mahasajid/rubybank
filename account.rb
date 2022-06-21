require 'csv'

class Filreader
    def initialize
        @account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    end

    def getinfo
        @account_info
    end

    def setinfo(account_info)
        File.open("Accounts.csv", 'w') do |f|
            f.write(account_info.to_csv)
        end
    end

end
class User < Filreader

    fileread = Filreader.new
    @account_info = fileread.getinfo

    # def initialize(account_info)
    # @account_info = account_info
    # end

    def view_user
        puts "Enter Your Account Title:"
        title_search = gets
        if @account_info.by_col[1].include?(title_search)
            idx = @account_info.by_col[1].find_index(title_search) 
            puts @account_info[idx.to_i]
        else
            puts "\n \n User Not Found \n \n"
        end
    end

    def view_all
        @account_info.each {|i| puts i}
    end

    def add_user
        puts " Enter New Account Title:"
        title_search = gets
        puts "Enter Balance"
        balance_amount = gets
        idx = @account_info.by_col[0][-1].to_i + 1
        CSV.open("Accounts.csv", "a+") do |csv|
            csv << [idx, title_search, balance_amount.to_f]
        end
    end

    def edit_user
        puts "Enter Your Account Title:"
        title_search = gets
        if @account_info.by_col[1].include?(title_search)
            puts " Enter New Account Title:"
            new_title= gets

            idx = @account_info.by_col[1].find_index(title_search) 
            @account_info[idx.to_i]['title'] = new_title
            fileread = Filreader.new
            fileread.setinfo(@account_info)

        else
            puts " \n \n User not found \n \n "
        end

    end

    def delete_user
    
        puts "Enter Your Account Title:"
        title_search = gets

        if @account_info.by_col[1].include?(title_search)

            idx = @account_info.by_col[1].find_index(title_search)

            table = CSV.table("Accounts.csv")

            table.delete(idx) 

            File.open("Accounts.csv", 'w') do |f|
                f.write(table.to_csv)
            end
        else
            puts " \n \n User not found \n \n "
        end
    end

    def balance_change(options={})

        puts "Enter Your Account Title:"
        title_search = gets
        if @account_info.by_col[1].include?(title_search)
                puts "Enter amount:"
                new_amount = gets

                idx = @account_info.by_col[1].find_index(title_search) 

                remaining_balance = @account_info[idx.to_i]['balance'].to_f - new_amount.to_f 

                @account_info[idx.to_i]['balance'] = new_amount.to_f + @account_info[idx.to_i]['balance'].to_f if options[:add]
                if options[:withdraw]
                    # remaining_balance = @account_info[idx.to_i]['balance'].to_f - new_amount.to_f 
                    remaining_balance >=0 ? @account_info[idx.to_i]['balance'] = remaining_balance : (puts "\n \n Insufficient Balance \n \n")
                end
                
                if options[:transfer]  
                    if remaining_balance >=0 
                        puts "Enter Title of Beneficiary"
                        beneficiary = gets
        
                        if @account_info.by_col[1].include?(beneficiary)
        
                        idx2 = @account_info.by_col[1].find_index(beneficiary) 

                        @account_info[idx.to_i]['balance'] = remaining_balance 
                        @account_info[idx2.to_i]['balance'] = new_amount.to_f + @account_info[idx2.to_i]['balance'].to_f
                    else
                        puts " \n \n User not found \n \n"
                    end
                    




                    else
                        puts "\n \n Insufficient Balance \n \n"

                        
                    end

                end

                fileread = Filreader.new
                fileread.setinfo(@account_info)
                

        
            

        else

            puts " \n \n User not found \n \n"
        end


    end




end

user_session = User.new()
while 1==1
    puts "Menu \n 1. Add New User \n 2. View User \n 3. View All Users \n 4. Edit User \n 5. Delete User \n 6. Deposit Amount \n 7. Withdraw Amount \n 8. Transfer\n 0. Quit"

    menu_selection = gets
    case menu_selection.to_i
    when 1
        user_session.add_user
    when 2
        user_session.view_user
    when 3
        user_session.view_all
    when 4
        user_session.edit_user
    when 5
        user_session.delete_user
    when 6
        user_session.balance_change(add:true)
    when 7
        user_session.balance_change(withdraw:true)
    when 8
        user_session.balance_change(transfer:true)
    when 0
        break
    else
        "Invalid Selection"
    end
end


#new_user
#view_user
#edit_user
#delete_user
#view_all
# balance_change(withdraw:true)
# balance_change(add:true)
#balance_change(transfer:true)
