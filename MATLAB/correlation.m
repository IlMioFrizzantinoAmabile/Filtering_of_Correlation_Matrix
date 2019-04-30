data_start = '01012000';
data_end = '01012018';
dati_struct = hist_stock_data(data_start,data_end,'tickers_list.txt');
%dati_struct = hist_stock_data(data_start,data_end,'tickers_list_SHORT.txt');
%dati_struct = hist_stock_data(data_start,data_end,'tickers_list_SHORTER.txt');
[~,dati_size] = size(dati_struct);
[dati_len,~] = size(dati_struct(1).AdjClose);
dati = zeros(dati_size,dati_len);
counter=1;
for i=1:dati_size
    [len,~] = size(dati_struct(i).AdjClose);
    if len>=dati_len
        for j=1:dati_len
            dati(counter,j) = dati_struct(i).AdjClose(j);
        end
        counter=counter+1;
    end
end

BIG_DATA = zeros(counter,dati_len);
BIG_DATA(:,:)=dati(1:counter,:);
%figure; hold on
%plot(BIG_DATA')
%hold off