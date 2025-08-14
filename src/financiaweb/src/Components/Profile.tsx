import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import IconButton from '@mui/material/IconButton';
import Avatar from '@mui/material/Avatar';
import Tooltip from '@mui/material/Tooltip';
import { lazy } from 'react';
import { useAuth } from '../contexts/AuthContext';

// Dynamic imports para componentes pesados
const Menu = lazy(() => import('@mui/material/Menu'))
const MenuItem = lazy(() => import('@mui/material/MenuItem'))
const ListItemIcon = lazy(() => import('@mui/material/ListItemIcon'))
const Divider = lazy(() => import('@mui/material/Divider'))

// lazy imports para iconos
const PersonAdd = lazy(() => import('@mui/icons-material/PersonAdd'))
const Settings = lazy(() => import('@mui/icons-material/Settings'))
const Logout = lazy(() => import('@mui/icons-material/Logout'))

const Profile = () => {
    const navigate = useNavigate();
    const {photoPreviewContext}=useAuth()
    const { user, logout } = useAuth();
    const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
    const open = Boolean(anchorEl);

    const handleClick = (event: React.MouseEvent<HTMLElement>) => {
        setAnchorEl(event.currentTarget);
    };
    const handleClose = () => setAnchorEl(null);

    const handleLogout = async () => {
        try {
            logout();
            navigate('/');
            handleClose();
        } catch (error) {
            console.error('Error al cerrar sesión:', error);
        }
    };

    return (
        <>
            <Tooltip title="Configuración de cuenta">
                <IconButton
                    onClick={handleClick}
                    size="small"
                    sx={{ ml: 2 }}
                    aria-controls={open ? 'account-menu' : undefined}
                    aria-haspopup="true"
                    aria-expanded={open ? 'true' : undefined}
                >
                    <Avatar
                        sx={{ width: 32, height: 32 }}
                        src={photoPreviewContext ? photoPreviewContext : undefined}
                    >
                        {!photoPreviewContext && (user?.name?.[0]?.toUpperCase() || "U")}
                    </Avatar>
                </IconButton>
            </Tooltip>
            {open && (
                <Menu
                    anchorEl={anchorEl}
                    id="account-menu"
                    open={open}
                    onClose={handleClose}
                    onClick={handleClose}
                    slotProps={{
                        paper: {
                            elevation: 0,
                            sx: {
                                overflow: 'visible',
                                filter: 'drop-shadow(0px 2px 8px rgba(0,0,0,0.32))',
                                mt: 1.5,
                                '& .MuiAvatar-root': {
                                    width: 32,
                                    height: 32,
                                    ml: -0.5,
                                    mr: 1,
                                },
                                '&::before': {
                                    content: '""',
                                    display: 'block',
                                    position: 'absolute',
                                    top: 0,
                                    right: 14,
                                    width: 10,
                                    height: 10,
                                    bgcolor: 'background.paper',
                                    transform: 'translateY(-50%) rotate(45deg)',
                                    zIndex: 0,
                                },
                            },
                        },
                    }}
                    transformOrigin={{ horizontal: 'right', vertical: 'top' }}
                    anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
                >
                    <MenuItem onClick={() => { navigate('/cuenta'); handleClose(); }}>
                        <Avatar /> Perfil
                    </MenuItem>
                    <MenuItem onClick={handleLogout}>
                        <ListItemIcon>
                            <Logout fontSize="small" />
                        </ListItemIcon>
                        Cerrar sesión
                    </MenuItem>
                </Menu>
            )}
        </>
    )
}

export default Profile