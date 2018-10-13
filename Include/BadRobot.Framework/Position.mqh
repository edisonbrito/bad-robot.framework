//+------------------------------------------------------------------+
//|                                   Copyright 2018, Erlon F. Souza |
//|                                       https://github.com/erlonfs |
//+------------------------------------------------------------------+

#property copyright "Copyright 2018, Erlon F. Souza"
#property link      "https://github.com/erlonfs"

#include <Trade\Trade.mqh>
#include <BadRobot.Framework\Enum.mqh>

class Position
{
	private:		
	
		MqlTick _price;
		string _symbol;
		double _volume;
		int _spread;
		int _stopGain;
		int _stopLoss;
		ENUM_TIMEFRAMES _period;
		ENUM_LAST_PRICE_TYPE _lastPriceType;
		
		CTrade _trade;
		CPositionInfo _positionInfo;
		
	public:
	
		Position()
		{
			
		}
		
		~Position()
		{
		
		}	
		
		Position(const Position& other){
			this = other;
		}		
		
		void SetSymbol(string symbol)
		{
			_symbol = symbol;
		};
	
		void SetVolume(double volume)
		{
			_volume = volume;
		}
	
		double GetVolume()
		{
			return _volume;
		};;
	
		string GetSymbol()
		{
			return _symbol;
		}
	
		void SetSpread(int value)
		{
			_spread = value;
		};
	
		int GetSpread()
		{
			return _spread;
		}
	
		void SetStopGain(int value)
		{
			_stopGain = value;
		};
	
		int GetStopGain()
		{
			return _stopGain;
		};
	
		void SetStopLoss(int value)
		{
			_stopLoss = value;
		};
	
		int GetStopLoss()
		{
			return _stopLoss;
		};		
		
		void SetPeriod(ENUM_TIMEFRAMES period)
		{
			_period = period;
		};
	
		ENUM_TIMEFRAMES GetPeriod()
		{
			return _period;
		};
	
		void SetLastPriceType(ENUM_LAST_PRICE_TYPE value)
		{
			_lastPriceType = value;
		};
		
		ENUM_LAST_PRICE_TYPE GetLastPriceType()
		{
			return _lastPriceType;
		};		
		
		int GetPositionType()
		{
			return (int)PositionGetInteger(POSITION_TYPE);
		}
		
		bool IsPositionTypeBuy()
		{
		   return GetPositionType() == POSITION_TYPE_BUY;
		}
		
		bool IsPositionTypeSell()
		{
		   return GetPositionType() == POSITION_TYPE_SELL;
		}	
	
		double GetPositionGain()
		{
			return PositionGetDouble(POSITION_TP);
		}
		
		double GetPositionProfit()
		{
			return PositionGetDouble(POSITION_PROFIT);
		}	
	
		double GetPositionLoss()
		{
			return PositionGetDouble(POSITION_SL);
		}
		
		double GetSymbolTickSize()		
		{	
			return SymbolInfoDouble(GetSymbol(), SYMBOL_TRADE_TICK_SIZE);		
		}
	
		int GetPositionMagicNumber()
		{
			return (int)PositionGetInteger(POSITION_MAGIC);
		}
	
		double GetPositionPriceOpen()
		{
			return NormalizeDouble(PositionGetDouble(POSITION_PRICE_OPEN), _Digits);
		}
	
		double GetPositionVolume()
		{
			return PositionGetDouble(POSITION_VOLUME);
		}	
				
		string GetPositionVolumeText()
		{
			return HasPositionOpen() ? (IsPositionTypeSell() ? "-" : "") + (string)GetPositionVolume() : "0";
		}
	
		bool HasPositionLossOrPositionGain()
		{
			return GetPositionLoss() > 0.0 && GetPositionGain() > 0.0;
		}		
		
		bool HasPositionOpen()
		{
			return _positionInfo.Select(GetSymbol()) && GetPositionMagicNumber() == _trade.RequestMagic();
		}
	
		bool HasOrderOpen()
		{
			int orderCount = 0;
	
			for (int i = 0; i < OrdersTotal(); i++)
			{
				if (OrderSelect(OrderGetTicket(i)) && OrderGetString(ORDER_SYMBOL) == GetSymbol() && OrderGetInteger(ORDER_MAGIC) == _trade.RequestMagic())
				{
					orderCount++;
				}
			}
	
			return orderCount > 0;
			
		}		
		
		double ToPoints(int tickValue)
		{
		   return tickValue * GetSymbolTickSize();
		}	
		
		double GetLastPrice()
		{
		   if(GetLastPriceType() == ENUM_LAST_PRICE_TYPE_LAST)
		   {
		      return _price.last;
		   }
		   
		   if(GetLastPriceType() == ENUM_LAST_PRICE_TYPE_ASK_OR_BID)
		   {	
		      return (IsPositionTypeSell() ? _price.ask : _price.bid);	   
		   }
		   
		   return NormalizeDouble(0, _Digits);
		   
		}
		
		datetime GetLastTime()
		{	   
		   return _price.time;	   
		}			
		
		void OnTick()
		{
			if (!SymbolInfoTick(GetSymbol(), _price))
			{
				Alert("Erro ao obter a última cotação de preço: ", GetLastError());
				return;
			}
		}   	
	
};