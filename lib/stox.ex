defmodule Stox do
  @username Application.get_env(:stox, :username)
  @password Application.get_env(:stox, :password)
  @base_url "https://api.intrinio.com/"
  @headers %{"Authorization" => "Basic " <> Base.encode64("#{@username}:#{@password}")}

  #calculate Graham's magic number
  def magic_number(ticker) do
    pbv = get_pbv(ticker)
    pe = get_pe(ticker)

    magic_num = pbv * pe

    cond do 
      magic_num <= 22.5 -> 
        IO.puts "Look into that shit"
      true -> 
        "Not worth it"
    end
  end

  #get p/bv 
  #must be lower than 1.5 
  def get_pbv(ticker) do 
    %HTTPoison.Response{body: resp} = 
      HTTPoison.get! @base_url <> 
         "data_point?identifier=#{ticker}"
         <> "&item=pricetobook", 
         @headers 

     resp 
       |> Poison.decode! 
       |> Map.get("value") 
  end

  #get p/e 
  #must be lower than 15
  def get_pe(ticker) do 
    %HTTPoison.Response{body: resp} = 
      HTTPoison.get! @base_url <> 
         "data_point?identifier=#{ticker}"
         <> "&item=pricetoearnings", 
         @headers 

     resp 
       |> Poison.decode! 
       |> Map.get("value") 
    
  end
end

