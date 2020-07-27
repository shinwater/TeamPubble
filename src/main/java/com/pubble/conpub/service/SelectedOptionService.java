package com.pubble.conpub.service;

import com.pubble.conpub.repository.SelectedOptionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class SelectedOptionService {

    @Autowired
    private SelectedOptionRepository selectedOptionRepository;

    @Transactional
    public void deleteCart(String[] check){
        System.out.println("SelectedOptionService!!");
        selectedOptionRepository.delete(check);
    }
}
