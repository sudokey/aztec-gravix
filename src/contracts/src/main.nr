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
        context::{PrivateContext, PublicContext, Context},
        oracle::{
            get_public_key::get_public_key,
        },
        state_vars::{map::Map, public_state::PublicState, set::Set, singleton::Singleton},
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
        positions: Map<Map<Singleton<Position, POSITION_SERIALIZED_LEN>>>
    }

    impl Storage {
        fn init(context: Context) -> pub Self {
            Storage {
                admin: PublicState::new(
                    context,
                    1,
                    AztecAddressSerializationMethods,
                ),
                markets: Map::new(
                    context,
                    2,
                    |context, slot| {
                        PublicState::new(
                            context,
                            slot,
                            MarketSerializationMethods,
                        )
                    },
                ),
                liquidity: PublicState::new(
                    context,
                    3,
                    SafeU120SerializationMethods,
                ),
                // -------------------- PRIVATE ----------------------
                positions: Map::new(
                    context,
                    4,
                    |context, slot| {
                        Map::new(
                            context,
                            slot,
                            |context, slot| {
                                Singleton::new(context, slot, PositionSerializationMethods)
                            }
                        )
                    },
                )
            }
        }
    }


    #[aztec(private)]
    fn constructor(admin: AztecAddress) {
        let selector = compute_selector("_initialize((Field))");
        context.call_public_function(context.this_address(), selector, [admin.address]);
    }

    // ---------------------------------------- PUBLIC -----------------------------------------------
    #[aztec(public)]
    internal fn _initialize(
        new_admin: AztecAddress,
    ) {
        storage.admin.write(new_admin);
    }
}
