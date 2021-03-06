import { connect } from 'react-redux';

import ServerNameButton from './server_name_button';

const mapStateToProps = (state, ownProps) => ({
  servers: state.entities.servers
})

export default connect(mapStateToProps, null)(ServerNameButton);
