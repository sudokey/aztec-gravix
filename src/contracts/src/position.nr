use dep::aztec::types::type_serialization::TypeSerializationInterface;

struct Position {
    marketIdx: u8,
    posType: u8, // 0 - long, 1 - short
    initialCollateral: u120,
    openFee: u120,
    openPrice: u120, // price after spread apply
    markPrice: u120, // market price on moment of position creation
    leverage: u32,
    borrowBaseRatePerHour: u64, // we store rate on moment of position creation because rate could be changed in market config
    liquidationThresholdRate: u64,
    createdAt: u32
}

global POSITION_SERIALIZED_LEN: Field = 10;

fn deserializePosition(fields: [Field; POSITION_SERIALIZED_LEN]) -> Position {
    Position {
        marketIdx: fields[0] as u8,
        posType: fields[1] as u8,
        initialCollateral: fields[2] as u120,
        openFee: fields[3] as u120,
        openPrice: fields[4] as u120,
        markPrice: fields[5] as u120,
        leverage: fields[6] as u32,
        borrowBaseRatePerHour: fields[7] as u64,
        liquidationThresholdRate: fields[8] as u64,
        createdAt: fields[9] as u32
    }
}

fn serializePosition(market: Position) -> [Field; POSITION_SERIALIZED_LEN] {
    [
        market.marketIdx as Field,
        market.posType as Field,
        market.initialCollateral as Field,
        market.openFee as Field,
        market.openPrice as Field,
        market.markPrice as Field,
        market.leverage as Field,
        market.borrowBaseRatePerHour as Field,
        market.liquidationThresholdRate as Field,
        market.createdAt as Field
    ]
}

impl Position {
    fn serialize(self: Self) -> [Field; POSITION_SERIALIZED_LEN] {
        serializePosition(self)
    }
}

global PositionSerializationMethods = TypeSerializationInterface {
    deserialize: deserializePosition,
    serialize: serializePosition
};