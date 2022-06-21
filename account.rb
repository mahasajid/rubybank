require 'csv'


def view_user
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    puts "Enter Your Account Title:"
    title_search = gets

    idx = account_info.by_col[1].find_index(title_search) 
    puts account_info[idx.to_i]
end

def view_all
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    account_info.each {|i| puts i}
end

def add_user
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    puts " Enter New Account Title:"
    title_search = gets
    puts "Enter Balance"
    balance_amount = gets
    idx = account_info.by_col[0].length + 1
    CSV.open("Accounts.csv", "a+") do |csv|
        csv << [idx, title_search, balance_amount.to_f]
      end
end

def edit_user
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    puts "Enter Your Account Title:"
    title_search = gets

    puts " Enter New Account Title:"
    new_title= gets

    idx = account_info.by_col[1].find_index(title_search) 
    account_info[idx.to_i]['title'] = new_title

    File.open("Accounts.csv", 'w') do |f|
        f.write(account_info.to_csv)
    end

end

def delete_user
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)
    puts "Enter Your Account Title:"
    title_search = gets
    idx = account_info.by_col[1].find_index(title_search)

    table = CSV.table("Accounts.csv")

    table.delete(idx) 

    File.open("Accounts.csv", 'w') do |f|
        f.write(table.to_csv)
    end
end

def balance_change(options={})
    account_info = CSV.parse(File.read("Accounts.csv"), headers:true)

    puts "Enter Your Account Title:"
    title_search = gets

    puts "Enter amount:"
    new_amount = gets

    idx = account_info.by_col[1].find_index(title_search) 
    account_info[idx.to_i]['balance'] = new_amount.to_f + account_info[idx.to_i]['balance'].to_f if options[:add]
    account_info[idx.to_i]['balance'] = account_info[idx.to_i]['balance'].to_f - new_amount.to_f if options[:withdraw]  
    
    if options[:transfer]  
        puts "Enter Title of Beneficiary"
        beneficiary = gets

        idx2 = account_info.by_col[1].find_index(beneficiary) 

        account_info[idx.to_i]['balance'] = account_info[idx.to_i]['balance'].to_f - new_amount.to_f
        account_info[idx2.to_i]['balance'] = new_amount.to_f + account_info[idx2.to_i]['balance'].to_f

    end
    File.open("Accounts.csv", 'w') do |f|
        f.write(account_info.to_csv)
    end

end



while 1==1
puts "Menu \n 1. Add New User \n 2. View User \n 3. View All Users \n 4. Edit User \n 5. Delete User \n 6. Deposit Amount \n 7. Withdraw Amount \n 8. Transfer\n 0. Quit"

menu_selection = gets
case menu_selection.to_i
when 1
    add_user
when 2
    view_user
when 3
    view_all
when 4
    edit_user
when 5
    delete_user
when 6
    balance_change(add:true)
when 7
    balance_change(withdraw:true)
when 8
    balance_change(transfer:true)
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