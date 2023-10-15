mod market;
mod position;
mod safe_u120_serialization;

contract Blank {
    use dep::std::option::Option;
    use dep::safe_math::SafeU120;

    use dep::value_note::{
        balance_utils,
        utils::{increment, decrement},
        value_note::{VALUE_NOTE_LEN, ValueNote, ValueNoteMethods},
    };
    
    use dep::aztec::{
        abi,
        oracle::{
            get_public_key::get_public_key,
        },
        state_vars::{map::Map, public_state::PublicState, set::Set},
        types::type_serialization::{
            field_serialization::{FieldSerializationMethods, FIELD_SERIALIZED_LEN},
            bool_serialization::{BoolSerializationMethods, BOOL_SERIALIZED_LEN},
            aztec_address_serialization::{AztecAddressSerializationMethods, AZTEC_ADDRESS_SERIALIZED_LEN},
        },
        types::address::{AztecAddress},
        selector::compute_selector,
    };
    use crate::market::{MARKET_SERIALIZED_LEN, Market, MarketSerializationMethods};
    use crate::safe_u120_serialization::{SafeU120SerializationMethods, SAFE_U120_SERIALIZED_LEN};
    use crate::position::{POSITION_SERIALIZED_LEN, PositionSerializationMethods, Position};

    struct Storage {
        admin: PublicState<AztecAddress, AZTEC_ADDRESS_SERIALIZED_LEN>,
        markets: Map<PublicState<Market, MARKET_SERIALIZED_LEN>>,
        liquidity: PublicState<SafeU120, SAFE_U120_SERIALIZED_LEN>,
        positions: Map<Map<Position>>
    }


    #[aztec(private)]
    fn constructor() {}
}
