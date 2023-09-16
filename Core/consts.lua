CONSTS = {
    IS_SERVER = IsDuplicityVersion(),
    IS_CLIENT = not IsDuplicityVersion(),
}

if CONSTS.IS_CLIENT then
    CONSTS.IS_REDM = GetGameName() == 'redm' and true or false
    CONSTS.IS_FIVEM = GetGameName() == 'fivem' and true or false
end