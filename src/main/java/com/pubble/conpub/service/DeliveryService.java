package com.pubble.conpub.service;

import com.pubble.conpub.domain.Delivery;
import com.pubble.conpub.repository.DeliveryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class DeliveryService {

    @Autowired
    private DeliveryRepository deliveryRepository;

    @Transactional
    public List<Delivery> findDelivery(Long no){
        return deliveryRepository.find(no);
    }

}
