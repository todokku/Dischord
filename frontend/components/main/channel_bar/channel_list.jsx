import React from 'react';

import ChannelListItem from './channel_list_item';

class ChannelList extends React.Component {
  constructor(props) {
    super(props);
  }


  render() {
    const channels = this.props.channels.filter(el => Number(el.serverId) === Number(this.props.match.params  .serverId));
    const channelItems =
      channels.length > 0 ? 
        channels.map(channel => <ChannelListItem key={channel.id} channel={channel} changeActiveChannel={this.props.changeActiveChannel}/>)
        : null
    return (
      <div id="channel-list-container">
        <div id="channel-list-header-container">
          <h2 id="channel-list-header-text">Text Channels</h2>
          <svg id="channel-list-add-channel-icon" xmlns="http://www.w3.org/2000/svg" aria-hidden="false" width="24" height="24" viewBox="0 0 24 24">
            <path fill="#43B581" d="M21 11.001H13V3.00098H11V11.001H3V13.001H11V21.001H13V13.001H21V11.001Z"></path>
          </svg>
        </div>
        {channelItems}
      </div>
    )
  }
}

export default ChannelList;